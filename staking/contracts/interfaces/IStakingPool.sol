// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface IStakingPool {
    // Views
    function lastTimeRewardApplicable() external view returns (uint256);

    function rewardPerToken() external view returns (uint256);

    function earned(address account) external view returns (uint256);

    function getRewardForDuration() external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    // Mutative

    function deposit(uint256 amount) external;

    function withdraw(uint256 amount) external;

    function getReward() external;

    function unstake() external;
}