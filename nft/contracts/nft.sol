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
    uint public totalAllItemSupply = 0;
    uint public totalAllItemQuantity = 100;

    uint public tier1Weight = 5;
    uint public tier2Weight = 25;
    uint public tier3Weight = 120;
    uint public tier4Weight = 300;
    uint public tier5Weight = 500;

    uint public itemPerTier = 5;

    uint public randNonce = 0;

    uint[] public items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25];

    // item attribute
    attributes public _attributes;

    // Access Control roles
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

    // Mapping token id to item id
    mapping (uint256=>uint) public mapTokenIdWithItem;

    // Mapping total supply of item id
    mapping (uint=>uint256) public mapItemSupply;

    constructor(string memory _name, string memory _symbol, address initialOwner, address _attributeAddress) Ownable(initialOwner) ERC721(_name, _symbol) {
        _attributes = attributes(_attributeAddress);
        _grantRole(OPERATOR_ROLE, initialOwner);
    }

    function setNewAttribute(address _attributeAddress) external onlyOwner {
            _attributes = attributes(_attributeAddress);
            for (uint i = minItemId; i <= maxItemId; i ++) {
                mapItemSupply[i] = 0;
            }
            totalAllItemSupply = 0;
    }

    function setNewOperator(address _operatorAddress) external onlyOwner {
        _grantRole(OPERATOR_ROLE, _operatorAddress);
    }


    function mint(address recipient) public payable returns (uint256)  {
        require(hasRole(OPERATOR_ROLE, msg.sender) || msg.sender == owner(), "not owner or operator role");
        require(totalAllItemSupply < totalAllItemQuantity, "Exceeded max limit of allowed all items mint");

        // remove item which exceed max limit quantity
        for (uint i = 0; i < items.length; i ++) {
            // get item attributes
            attributes.attribute memory _attribute = _attributes.attribute_by_id(items[i]);
            if (mapItemSupply[items[i]] >= _attribute.quantity) {
                // remove index of items
                if (i <= items.length){
                    for (uint index = i; index < items.length-1; index++){
                        items[index] = items[index+1];
                    }
                }
                items.pop();
                continue;
            }
        }

        // calculate weight for items
        uint[] memory weightOfItem = new uint[](items.length);
        for (uint i = 0; i < items.length; i ++) {
            // get item attributes
            attributes.attribute memory _attribute = _attributes.attribute_by_id(items[i]);
            // calculate weight for item
            if (_attribute.tier == 1) {
                weightOfItem[i] = tier1Weight/itemPerTier;
            } else if (_attribute.tier == 2) {
                weightOfItem[i] = tier2Weight/itemPerTier;
            } else if (_attribute.tier == 3) {
                weightOfItem[i] = tier3Weight/itemPerTier;
            } else if (_attribute.tier == 4) {
                weightOfItem[i] = tier4Weight/itemPerTier;
            } else if (_attribute.tier == 5) {
                weightOfItem[i] = tier5Weight/itemPerTier;
            }
        }

        // calculate cumulative weight
        uint[] memory cumulativeWeights = new uint[](weightOfItem.length);
        for (uint i = 0; i < weightOfItem.length; i ++){
            if (i == 0) {
                cumulativeWeights[i] = weightOfItem[i];
            } else {
                cumulativeWeights[i] += weightOfItem[i] + cumulativeWeights[i-1];
            }
        }

        // random is belong range [1, max of cumulativeWeights)
        uint random = uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % (cumulativeWeights[cumulativeWeights.length-1]);
        randNonce += 1;

        // pick item random
        uint itemId = 0;
        for (uint i = 0; i < cumulativeWeights.length; i ++){
            if (cumulativeWeights[i] > random){
                itemId = items[i];
                break;
            }
        }

        require(itemId > 0, "Not found valid item");

        attributes.attribute memory _attr = _attributes.attribute_by_id(itemId);
        require(mapItemSupply[itemId] < _attr.quantity, "Exceeded max limit of allowed item mint");

        uint256 newTokenId = ++tokenId;

        // map token id with item id
        mapTokenIdWithItem[newTokenId] = itemId;

        // increase total supply of item id
        mapItemSupply[itemId] += 1;

        // increase total items supply
        totalAllItemSupply += 1;

        _safeMint(recipient, newTokenId);

        return newTokenId;
    }

    function getTokenAttribute(uint256 _tokenId) public view returns(attributes.attribute memory _attribute) {
        attributes.attribute memory _attr = _attributes.attribute_by_id(mapTokenIdWithItem[_tokenId]);
        return _attr;
    }

    // @return The total supply of item id
    function totalMaxSupplyOfItem(uint _item_id) public view returns (uint256) {
        return mapItemSupply[_item_id];
    }

    // @return The total supply of all items
    function totalMaxSupplyOfItems() public view returns (uint256) {
        return totalAllItemSupply;
    }

    // @return The total supply of token
    function totalMaxSupplyOfToken() public view returns (uint256) {
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
