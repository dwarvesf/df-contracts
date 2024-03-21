// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./nft.sol";

contract NFTFactory {
    Nft[] public nftArray;

    event NewNFT(address indexed nft, string name, string symbol);

    function createNft(
        string memory name,
        string memory symbol,
        address initialOwner,
        address _attributes
    ) public {
        Nft nft = new Nft(name, symbol, initialOwner, _attributes);
        nftArray.push(nft);
        emit NewNFT(address(nft), name, symbol);
    }
}
