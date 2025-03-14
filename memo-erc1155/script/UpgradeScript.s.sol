// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Script.sol";
import "../src/DwarvesMemo.sol";

// Notes: 
// 1. Replace `PROXY_ADDRESS` with the address of the proxy contract you want to upgrade before running the script
// 2. Replace `INITIAL_URI` with the initial URI for the NFT metadata
contract UpgradeScript is Script {
    function run() external {
        vm.startBroadcast();

        address PROXY_ADDRESS = 0x742D35Cc6634c0532925A3b844F5131B03f8d34c;
        string memory INITIAL_URI = "https://example.com/metadata/{id}.json";

        // Deploy the new implementation contract
        DwarvesMemo newImplementation = new DwarvesMemo();

        DwarvesMemo proxy = DwarvesMemo(address(PROXY_ADDRESS));
        proxy.upgradeToAndCall(
            address(newImplementation),
            abi.encodeWithSelector(
                DwarvesMemo.initialize.selector,
                INITIAL_URI
            )
        );

        vm.stopBroadcast();
    }
}
