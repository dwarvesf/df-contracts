// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

interface attributes {
    struct attribute {
        uint8 id;
        uint8 tier;
        uint8 rarity;
        uint8 quantity;
        uint8 boostStaking;
        uint256 duration;
        string icon;
        string consumables;
        string description;
    }

    function attribute_by_id(uint _id) external pure returns(attribute memory _attribute);
}

contract Nft is ERC721, AccessControl, Ownable  {
    uint256 public tokenId;
    uint public maxItemId = 25;
    uint public minItemId = 1;

    // item attribute
    attributes _attributes;

    // Access Control roles
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

    // Mapping token id to item id
    mapping (uint256=>uint) mapTokenIdWithItem;

    // Mapping total supply of item id
    mapping (uint=>uint256) totalSupplyItem;

    constructor(string memory _name, string memory _symbol, address initialOwner, address _attributeAddress) Ownable(initialOwner) ERC721(_name, _symbol) {
        _attributes = attributes(_attributeAddress);
        _grantRole(OPERATOR_ROLE, initialOwner);
    }

    function setNewAttribute(address _attributeAddress) external onlyOwner {
            _attributes = attributes(_attributeAddress);
            for (uint i = minItemId; i <= maxItemId; i ++) {
                totalSupplyItem[i] = 0;
            }
    }

    function setNewOperator(address _operatorAddress) external onlyOwner {
        _grantRole(OPERATOR_ROLE, _operatorAddress);
    }

    function mint(address recipient, uint item_id) public payable returns (uint256)  {
        require(hasRole(OPERATOR_ROLE, msg.sender) || msg.sender == owner(), "not owner or operator role");

        // get item attributes
        attributes.attribute memory _attribute = _attributes.attribute_by_id(item_id);

        require(item_id >= minItemId && item_id <= maxItemId, "invalid item id");

        require(totalSupplyItem[item_id] + 1 <= _attribute.quantity, "Exceeded max limit of allowed item mints");

        uint256 newTokenId = ++tokenId;

        // map token id with item id
        mapTokenIdWithItem[newTokenId] = item_id;

        // increase total supply of item id
        totalSupplyItem[item_id] += 1;

        _safeMint(recipient, newTokenId);

        return newTokenId;
    }

    function getTokenAttribute(uint256 _tokenId) public view returns(attributes.attribute memory _attribute) {
        attributes.attribute memory _attr = _attributes.attribute_by_id(mapTokenIdWithItem[_tokenId]);
        return _attr;
    }

    // @return The total supply of item id
    function totalMaxSupplyOfItem(uint _item_id) public view returns (uint256) {
        return totalSupplyItem[_item_id];
    }

    // @return The total supply of token
    function totalMaxSupply() public view returns (uint256) {
        return tokenId;
    }

    // @return mint of item id
    function getMintItemId() public view returns (uint256) {
        return minItemId;
    }

    // @return max of item id
    function getMaxItemId() public view returns (uint256) {
        return maxItemId;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
