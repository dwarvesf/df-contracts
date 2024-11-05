// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IcyBtcSwap} from "../src/IcyBtcSwap.sol";

contract CounterScript is Script {
    IcyBtcSwap public icyBtcSwap;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address icy = address(0xF289E3b222dd42B185b7E335fA3C5bd6D132441D);
        icyBtcSwap = new IcyBtcSwap(icy);

        vm.stopBroadcast();
    }
}
