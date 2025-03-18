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

    // Test Admin Functions

    function test_CreateTokenType() public {
        vm.prank(owner);
        uint256 tokenId = proxy.createTokenType("arweave-tx-id-123");
        assertEq(tokenId, 1, "First token ID should be 1");
    }

    function test_CreateTokenType_RevertIfNotOwner() public {
        vm.prank(user);
        vm.expectRevert();
        proxy.createTokenType("arweave-tx-id-123");
    }

    function test_UpdateTokenType() public {
        vm.prank(owner);
        proxy.createTokenType("arweave-tx-id-123");

        uint256 tokenId = proxy.getTokenId("arweave-tx-id-123");

        vm.prank(owner);
        proxy.updateTokenType(tokenId, "new-arweave-tx-id");

        string memory arweaveUrl = proxy.readNFT(tokenId);
        assertEq(arweaveUrl, "https://arweave.developerdao.com/new-arweave-tx-id", "Arweave URL should be updated");
    }

    function test_UpdateTokenType_RevertIfNotOwner() public {
        vm.prank(owner);
        proxy.createTokenType("arweave-tx-id-123");

        uint256 tokenId = proxy.getTokenId("arweave-tx-id-123");

        vm.prank(user);
        vm.expectRevert();
        proxy.updateTokenType(tokenId, "new-arweave-tx-id");
    }

    function test_UpdateTokenType_RevertIfTokenDoesNotExist() public {
        vm.prank(owner);
        vm.expectRevert();
        proxy.updateTokenType(1, "new-arweave-tx-id");
    }

    // Test Public Functions

    function test_ReadNFT() public {
        vm.prank(owner);
        proxy.createTokenType("arweave-tx-id-123");

        uint256 tokenId = proxy.getTokenId("arweave-tx-id-123");
        string memory arweaveUrl = proxy.readNFT(tokenId);
        assertEq(arweaveUrl, "https://arweave.developerdao.com/arweave-tx-id-123", "Arweave URL should match");
    }

    function test_ReadNFT_RevertIfTokenDoesNotExist() public {
        vm.expectRevert("Token type does not exist");
        proxy.readNFT(1);
    }

    function test_GetTokenId() public {
        vm.prank(owner);
        proxy.createTokenType("arweave-tx-id-123");

        uint256 tokenId = proxy.getTokenId("arweave-tx-id-123");
        assertEq(tokenId, 1, "Token ID should be 1");
    }

    function test_MintNFT() public {
        vm.prank(owner);
        proxy.createTokenType("arweave-tx-id-123");
        uint256 tokenId = proxy.getTokenId("arweave-tx-id-123");
        
        vm.prank(user);
        proxy.mintNFT(tokenId, 1);

        assertEq(proxy.balanceOf(user, tokenId), 1, "User should have 1 token");
        assertEq(proxy.getUniqueMinterCount(), 1, "Unique minters count should be 1");
    }

    function test_MintNFT_RevertIfTokenDoesNotExist() public {
        vm.prank(user);
        vm.expectRevert("Token type does not exist");
        proxy.mintNFT(1, 10);
    }

    function test_GetUniqueMinterCount() public {
        vm.prank(owner);
        proxy.createTokenType("arweave-tx-id-123");

        uint256 tokenId = proxy.getTokenId("arweave-tx-id-123");

        vm.prank(user);
        proxy.mintNFT(tokenId, 1);

        vm.prank(address(0x789));
        proxy.mintNFT(tokenId, 1);

        assertEq(proxy.getUniqueMinterCount(), 2, "Unique minters count should be 2");
    }

    function test_SetArweaveGatewayUrl() public {
        vm.prank(owner);
        proxy.setArweaveGatewayUrl("https://new-gateway.com/");

        vm.prank(owner);
        proxy.createTokenType("arweave-tx-id-123");

        uint256 tokenId = proxy.getTokenId("arweave-tx-id-123");
        string memory arweaveUrl = proxy.readNFT(tokenId);
        assertEq(arweaveUrl, "https://new-gateway.com/arweave-tx-id-123", "Arweave URL should use new gateway");
    }

    // Test minting multiple times from the same address
    function test_MintNFT_MultipleMints() public {
        vm.prank(owner);
        proxy.createTokenType("arweave-tx-id-123");

        uint256 tokenId = proxy.getTokenId("arweave-tx-id-123");
        
        vm.prank(user);
        proxy.mintNFT(tokenId, 5);
        
        vm.prank(user);
        proxy.mintNFT(tokenId, 10);
        
        assertEq(proxy.balanceOf(user, tokenId), 15, "User should have 15 tokens total");
        assertEq(proxy.getUniqueMinterCount(), 1, "Unique minters count should still be 1");
    }

    // Test minting with zero amount
    function test_MintNFT_ZeroAmount() public {
        vm.prank(owner);
        proxy.createTokenType("arweave-tx-id-123");

        uint256 tokenId = proxy.getTokenId("arweave-tx-id-123");
        
        vm.prank(user);
        proxy.mintNFT(tokenId, 0);
        
        assertEq(proxy.balanceOf(user, tokenId), 0, "User should have 0 tokens");
        assertEq(proxy.getUniqueMinterCount(), 1, "Unique minters count should be 1");
    }

    // Test updating token type to empty Arweave transaction ID
    function test_UpdateTokenType_ToEmptyArweaveTxId() public {
        vm.prank(owner);
        proxy.createTokenType("arweave-tx-id-123");

        uint256 tokenId = proxy.getTokenId("arweave-tx-id-123");
        
        vm.prank(owner);
        vm.expectRevert("Arweave transaction ID cannot be empty");
        proxy.updateTokenType(tokenId, "");
    }
}