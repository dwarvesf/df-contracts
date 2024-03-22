// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./StakingPool.sol";

contract StakingPoolFactory is Ownable {
    using SafeMath for uint;

    // immutables
    uint public stakingRewardsGenesis;

    // the staking pool key for which the rewards contract has been deployed
    string[] public stakingPoolKeys;

    struct PoolInfo {
        address stakingPoolAddress;
        address stakingToken;  
        address rewardToken;
        uint rewardAmount;  // The initial amount of reward tokens allocated (set during deployment in deploy)
        uint rewardProgressAmount; // Tracks the total amount of reward tokens already distributed to the staking pool contract.
        uint rewardTotalAmount; // The total amount of reward tokens planned for distribution (can be higher than rewardAmount).
    }

    // rewards info by string with format <staking_token>_<reward_token>
    mapping(string => PoolInfo) public stakingPoolInfoByStakingToken;

    constructor(
        uint _stakingRewardsGenesis,
        address initialOwner
    ) Ownable(initialOwner) {
        require(
            _stakingRewardsGenesis >= block.timestamp,
            "StakingPoolFactory::constructor: genesis too soon"
        );

        stakingRewardsGenesis = _stakingRewardsGenesis;
    }

    ///// permissioned functions

    // deploy a staking reward contract for the staking token, and store the reward amount
    // the reward will be distributed to the staking reward contract no sooner than the genesis
    function deploy(
        address stakingToken,
        address rewardToken,
        uint rewardAmount,
        uint rewardTotalAmount
    ) public onlyOwner {
        require(
            rewardAmount <= rewardTotalAmount,
            "StakingPoolFactory::deploy: rewardAmount must be less or equal rewardTotalAmount"
        );

        string memory poolKey = getStakingPoolKey(stakingToken, rewardToken);
        PoolInfo storage info = stakingPoolInfoByStakingToken[poolKey];
        require(
            info.stakingPoolAddress == address(0),
            "StakingPoolFactory::deploy: already deployed"
        );

        info.stakingPoolAddress = address(
            new StakingPool(
                /*_rewardsDistributor=*/ address(this),
                rewardToken,
                stakingToken
            )
        );
        info.stakingToken = stakingToken;
        info.rewardToken = rewardToken;
        info.rewardAmount = rewardAmount;
        info.rewardProgressAmount = 0;
        info.rewardTotalAmount = rewardTotalAmount;
        stakingPoolKeys.push(poolKey);
    }

    ///// permissionless functions

    // call notifyRewardAmount for all staking tokens.
    function notifyRewardAmounts() public onlyOwner {
        require(
            stakingPoolKeys.length > 0,
            "StakingPoolFactory::notifyRewardAmounts: called before any deploys"
        );
        for (uint i = 0; i < stakingPoolKeys.length; i++) {
            PoolInfo storage info = stakingPoolInfoByStakingToken[
                stakingPoolKeys[i]
            ];
            require(
                info.stakingPoolAddress != address(0),
                "StakingPoolFactory::notifyRewardAmount: not deployed"
            );

            notifyRewardAmount(stakingPoolKeys[i], info.rewardAmount);
        }
    }

    // transfer reward tokens to the deployed StakingPool contract
    // this is a fallback in case the notifyRewardAmounts costs too much gas to call for all contracts
    function notifyRewardAmount(
        string memory poolKey,
        uint rewardAmount
    ) public onlyOwner {
        require(
            block.timestamp >= stakingRewardsGenesis,
            "StakingPoolFactory::notifyRewardAmount: not ready"
        );

        PoolInfo storage info = stakingPoolInfoByStakingToken[poolKey];
        require(
            info.stakingPoolAddress != address(0),
            "StakingPoolFactory::notifyRewardAmount: not deployed"
        );

        if (info.rewardProgressAmount < info.rewardTotalAmount) {
            uint remaining = info.rewardTotalAmount.sub(
                info.rewardProgressAmount
            );
            require(
                remaining >= rewardAmount,
                "StakingPoolFactory::notifyRewardAmount: incorrect rewardAmount"
            );

            info.rewardProgressAmount = info.rewardProgressAmount.add(
                rewardAmount
            );
            require(
                IERC20(info.rewardToken).transfer(
                    info.stakingPoolAddress,
                    rewardAmount
                ),
                "StakingPoolFactory::notifyRewardAmount: transfer failed"
            );
            StakingPool(info.stakingPoolAddress).notifyRewardAmount(
                rewardAmount
            );
        }
    }

    function getStakingPoolKey(
        address stakingToken,
        address rewardToken
    ) private pure returns (string memory) {
        string memory stakingTokenStr = Strings.toHexString(
            uint256(uint160(stakingToken)),
            20
        );
        string memory rewardTokenStr = Strings.toHexString(
            uint256(uint160(rewardToken)),
            20
        );
        return string.concat(stakingTokenStr, "_", rewardTokenStr);
    }
}
