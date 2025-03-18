// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/src/Script.sol";
import "../src/DwarvesMemo.sol";

// Notes: 
// 1. Replace `PROXY_ADDRESS` with the address of the proxy contract you want to upgrade before running the script
// 2. Replace `INITIAL_URI` with the initial URI for the NFT metadata
contract UpgradeScript is Script {
    function run() external {
        vm.startBroadcast();

        address PROXY_ADDRESS = 0xb1e052156676750D193D800D7D91eA0C7cEeAdF0; // TODO: Replace with the address of the latest proxy contract you want to upgrade

        // Deploy the new implementation contract
        DwarvesMemo newImplementation = new DwarvesMemo();

        DwarvesMemo proxy = DwarvesMemo(address(PROXY_ADDRESS));
        bytes memory data = "";
        proxy.upgradeToAndCall(
            address(newImplementation),
            data
        );

        vm.stopBroadcast();
    }
}
