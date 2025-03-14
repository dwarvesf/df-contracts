// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Script.sol";
import "../src/DwarvesMemo.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy implementation contract
        DwarvesMemo implementation = new DwarvesMemo();

        // Deploy proxy contract
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(implementation),
            abi.encodeWithSelector(DwarvesMemo.initialize.selector, "https://example.com/metadata/{id}.json")
        );

        vm.stopBroadcast();
    }
}