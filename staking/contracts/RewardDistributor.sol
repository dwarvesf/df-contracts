// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import './interfaces/IRewardDistributor.sol';

abstract contract RewardsDistributor is IRewardDistributor {
    address public rewardsDistributor;

    modifier onlyRewardsDistributor() {
        require(msg.sender == rewardsDistributor, "Caller is not RewardsDistributor contract");
        _;
    }
}