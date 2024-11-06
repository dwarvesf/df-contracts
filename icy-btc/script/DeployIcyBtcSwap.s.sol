// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {IcyBtcSwap} from "../src/IcyBtcSwap.sol";

contract DeployIcyBtcSwap is Script {
    function run() external {
        // Retrieve private key from environment
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the contract
        address icy = address(0x5233E10cc24736F107fEda42ff0157e91Cf1F8b6);
        IcyBtcSwap icyBtcSwap = new IcyBtcSwap(icy);

        // Optional: Set initial signer if needed
        // address initialSigner = 0x...;
        // icyBtcSwap.setSigner(initialSigner);

        vm.stopBroadcast();

        // Log the deployment address
        console.log("IcyBtcSwap deployed to:", address(icyBtcSwap));
    }
}
