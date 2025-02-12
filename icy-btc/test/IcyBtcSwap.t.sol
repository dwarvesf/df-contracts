// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IcyBtcSwap} from "../src/IcyBtcSwap.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {MockERC20} from "./mocks/MockERC20.sol";

contract IcyBtcSwapTest is Test {
    IcyBtcSwap public icyBtcSwap;
    MockERC20 public icyToken;

    address public owner;
    address public user;
    uint256 public userPrivateKey;

    // Test data
    uint256 constant ICY_AMOUNT = 1000e18;
    string constant BTC_ADDRESS = "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh";
    uint256 constant BTC_AMOUNT = 1e8; // 1 BTC
    uint256 constant DEADLINE = type(uint256).max;

    function setUp() public {
        // Setup accounts
        owner = makeAddr("owner");
        (user, userPrivateKey) = makeAddrAndKey("user");

        vm.startPrank(owner);
        // Deploy mock ICY token
        icyToken = new MockERC20("ICY Token", "ICY", 18);

        // Deploy IcyBtcSwap
        icyBtcSwap = new IcyBtcSwap(address(icyToken));

        // Mint ICY tokens to user
        icyToken.mint(user, ICY_AMOUNT);
        vm.stopPrank();
    }

    function testSwap() public {
        // set signer first
        vm.startPrank(owner);
        icyBtcSwap.setSigner(user);
        vm.stopPrank();

        vm.startPrank(user);

        // Prepare swap data
        uint256 nonce = 0;
        bytes32 swapHash = icyBtcSwap.getSwapHash(
            ICY_AMOUNT,
            BTC_ADDRESS,
            BTC_AMOUNT,
            nonce,
            DEADLINE
        );

        // Sign the swap hash
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, swapHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        // Approve ICY tokens
        icyToken.approve(address(icyBtcSwap), ICY_AMOUNT);

        // Perform swap
        icyBtcSwap.swap(
            ICY_AMOUNT,
            BTC_ADDRESS,
            BTC_AMOUNT,
            nonce,
            DEADLINE,
            signature
        );

        // Assert ICY tokens were transferred
        assertEq(icyToken.balanceOf(user), 0);
        assertEq(icyToken.balanceOf(address(icyBtcSwap)), ICY_AMOUNT);

        vm.stopPrank();
    }

    function testRevertIcy() public {
        // First perform a swap
        testSwap();

        vm.startPrank(owner);

        // Prepare revert data
        uint256 nonce = 0;
        bytes32 revertHash = icyBtcSwap.getRevertIcyHash(
            ICY_AMOUNT,
            BTC_ADDRESS,
            BTC_AMOUNT,
            nonce,
            DEADLINE
        );

        // Sign the revert hash
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, revertHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        // Perform revert
        icyBtcSwap.revertIcy(
            ICY_AMOUNT,
            BTC_ADDRESS,
            BTC_AMOUNT,
            nonce,
            DEADLINE,
            signature
        );

        // Assert ICY tokens were returned
        assertEq(icyToken.balanceOf(owner), ICY_AMOUNT);
        assertEq(icyToken.balanceOf(address(icyBtcSwap)), 0);

        vm.stopPrank();
    }

    function testSetSigner() public {
        address newSigner = makeAddr("newSigner");

        // Only owner can set signer
        vm.prank(owner);
        icyBtcSwap.setSigner(newSigner);

        assertEq(icyBtcSwap.signerAddress(), newSigner);
    }

    function testFailSwapWithExpiredDeadline() public {
        vm.startPrank(user);

        uint256 expiredDeadline = block.timestamp - 1;
        uint256 nonce = 0;

        bytes32 swapHash = icyBtcSwap.getSwapHash(
            ICY_AMOUNT,
            BTC_ADDRESS,
            BTC_AMOUNT,
            nonce,
            expiredDeadline
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, swapHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        icyToken.approve(address(icyBtcSwap), ICY_AMOUNT);

        // This should fail
        icyBtcSwap.swap(
            ICY_AMOUNT,
            BTC_ADDRESS,
            BTC_AMOUNT,
            nonce,
            expiredDeadline,
            signature
        );

        vm.stopPrank();
    }
}
