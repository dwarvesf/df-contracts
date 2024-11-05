// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IcyBtcSwap} from "../src/IcyBtcSwap.sol";

contract IcyBtcSwapTest is Test {
    IcyBtcSwap public icyBtcSwap;

    function setUp() public {
        address icy = address(0xF289E3b222dd42B185b7E335fA3C5bd6D132441D);
        icyBtcSwap = new IcyBtcSwap(icy);
    }
}
