// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/src/Script.sol";
import "../src/DwarvesMemo.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

// Notes:
// Replace `INITIAL_URI` with the initial URI for the NFT metadata
contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();

        string memory INITIAL_URI = "https://example.com/metadata/{id}.json";

        // Deploy implementation contract
        DwarvesMemo implementation = new DwarvesMemo();

        // Deploy proxy contract
        new ERC1967Proxy(
            address(implementation),
            abi.encodeWithSelector(DwarvesMemo.initialize.selector, INITIAL_URI)
        );

        vm.stopBroadcast();
    }
}