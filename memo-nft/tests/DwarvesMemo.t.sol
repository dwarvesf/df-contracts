// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/src/Test.sol";
import "../src/DwarvesMemo.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DwarvesMemoTest is Test {
    DwarvesMemo public implementation;
    DwarvesMemo public proxy;
    address owner = address(0x123);
    address user = address(0x456);

    function setUp() public {
        // Deploy implementation contract
        implementation = new DwarvesMemo();

        // Deploy proxy contract and initialize it
        vm.prank(owner);
        proxy = DwarvesMemo(
            address(
                new ERC1967Proxy(
                    address(implementation),
                    abi.encodeWithSelector(DwarvesMemo.initialize.selector, "https://example.com/metadata/{id}.json")
                )
            )
        );
    }

    // Test Initialization
    function test_Initialization() public {
        assertEq(proxy.owner(), owner, "Owner should be set correctly");
    }

    // Test Admin Functions

    function test_CreateTokenType() public {
        vm.prank(owner);
        proxy.createTokenType(1, "arweave-tx-id-123");

        string memory arweaveUrl = proxy.readNFT(1);
        assertEq(arweaveUrl, "https://viewblock.io/arweave/tx/arweave-tx-id-123", "Arweave URL should match");
    }

    function test_CreateTokenType_RevertIfNotOwner() public {
        vm.prank(user);
        vm.expectRevert();
        proxy.createTokenType(1, "arweave-tx-id-123");
    }

    function test_UpdateTokenType() public {
        vm.prank(owner);
        proxy.createTokenType(1, "arweave-tx-id-123");

        vm.prank(owner);
        proxy.updateTokenType(1, "new-arweave-tx-id");

        string memory arweaveUrl = proxy.readNFT(1);
        assertEq(arweaveUrl, "https://viewblock.io/arweave/tx/new-arweave-tx-id", "Arweave URL should be updated");
    }

    function test_UpdateTokenType_RevertIfNotOwner() public {
        vm.prank(owner);
        proxy.createTokenType(1, "arweave-tx-id-123");

        vm.prank(user);
        vm.expectRevert();
        proxy.updateTokenType(1, "new-arweave-tx-id");
    }

    function test_UpdateTokenType_RevertIfTokenDoesNotExist() public {
        vm.prank(owner);
        vm.expectRevert("Token ID does not exist");
        proxy.updateTokenType(1, "new-arweave-tx-id");
    }

    // Test Public Functions

    function test_ReadNFT() public {
        vm.prank(owner);
        proxy.createTokenType(1, "arweave-tx-id-123");

        string memory arweaveUrl = proxy.readNFT(1);
        assertEq(arweaveUrl, "https://viewblock.io/arweave/tx/arweave-tx-id-123", "Arweave URL should match");
    }

    function test_ReadNFT_RevertIfTokenDoesNotExist() public {
        vm.expectRevert("Token ID does not exist");
        proxy.readNFT(1);
    }

    function test_MintNFT() public {
        vm.prank(owner);
        proxy.createTokenType(1, "arweave-tx-id-123");

        vm.prank(user);
        proxy.mintNFT(1, 10);

        assertEq(proxy.balanceOf(user, 1), 10, "User should have 10 tokens");
        assertEq(proxy.getUniqueMinterCount(), 1, "Unique minters count should be 1");
    }

    function test_MintNFT_RevertIfTokenDoesNotExist() public {
        vm.prank(user);
        vm.expectRevert("Token ID does not exist");
        proxy.mintNFT(1, 10);
    }

    function test_GetUniqueMinterCount() public {
        vm.prank(owner);
        proxy.createTokenType(1, "arweave-tx-id-123");

        vm.prank(user);
        proxy.mintNFT(1, 10);

        vm.prank(address(0x789));
        proxy.mintNFT(1, 5);

        assertEq(proxy.getUniqueMinterCount(), 2, "Unique minters count should be 2");
    }
}