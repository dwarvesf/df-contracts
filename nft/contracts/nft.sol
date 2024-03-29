// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

interface attributes {
    struct attribute {
        uint8 id;
        uint8 tier;
        uint8 rarity;
        uint8 quantity;
        uint8 boostStaking;
        uint256 duration;
        string consumables;
    }

    function attribute_by_id(uint _id) external pure returns(attribute memory _attribute);
}

contract Nft is ERC721, AccessControl, Ownable  {
    uint256 public tokenId;

    uint public maxItemId = 25;
    uint public minItemId = 1;

    uint public tier1Weight = 5;
    uint public tier2Weight = 25;
    uint public tier3Weight = 120;
    uint public tier4Weight = 350;
    uint public tier5Weight = 500;

    // item attribute
    attributes public _attributes;

    uint public randNonce = 0;

    uint[] private items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25];

    string private _baseTokenURI;
    uint private totalAllItemSupply = 0;
    uint private totalAllItemQuantity = 100;
    uint private itemPerTier = 5;

    // Access Control roles
    bytes32 private constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

    // Mapping token id to item id
    mapping (uint256=>uint) private mapTokenIdWithItem;

    // Mapping total supply of item id
    mapping (uint=>uint256) private mapItemSupply;

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

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        require(mapTokenIdWithItem[_tokenId] != 0, "ERC721Metadata: URI query for nonexistent token");

        string memory base = _baseURI();

        uint itemId = mapTokenIdWithItem[_tokenId];

        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, Strings.toString(itemId)));
    }

    function mint(address recipient, uint _luckyWeight) public payable returns (uint256)  {
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
                // weight of item tier1 = tier1Weight/itemPerTier1 + _luckyWeight/(itemPerTier1 + itemPerTier2)
                weightOfItem[i] = tier1Weight/itemPerTier + _luckyWeight/(itemPerTier*2);
            } else if (_attribute.tier == 2) {
                // weight of item tier2 = tier2Weight/itemPerTier2 + _luckyWeight/(itemPerTier1 + itemPerTier2)
                weightOfItem[i] = tier2Weight/itemPerTier + _luckyWeight/(itemPerTier*2);
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

    // @return The attribute of token id
    function getTokenAttribute(uint256 _tokenId) public view returns(attributes.attribute memory _attribute) {
        attributes.attribute memory _attr = _attributes.attribute_by_id(mapTokenIdWithItem[_tokenId]);
        return _attr;
    }

    // @return The attribute of item id
    function getItemAttribute(uint _itemId) public view returns (attributes.attribute memory _attribute) {
        attributes.attribute memory _attr = _attributes.attribute_by_id(_itemId);
        return _attr;
    }

    // @return The boostStaking of token id
    function getBoostStakingOfToken(uint256 _tokenId) public view returns (uint8 ) {
        attributes.attribute memory _attr = _attributes.attribute_by_id(mapTokenIdWithItem[_tokenId]);
        return _attr.boostStaking;
    }

    // @return The duration of token id
    function getDurationOfToken(uint256 _tokenId) public view returns (uint256 ) {
        attributes.attribute memory _attr = _attributes.attribute_by_id(mapTokenIdWithItem[_tokenId]);
        return _attr.duration;
    }

    // @return The total supply of item id
    function totalMaxSupplyOfItem(uint _itemId) public view returns (uint256) {
        return mapItemSupply[_itemId];
    }

    // @return The total supply of all items
    function totalMaxSupplyOfItems() public view returns (uint256) {
        return totalAllItemSupply;
    }

    // @return The total quantity of all items
    function totalQuantityOfItems() public view returns (uint256) {
        return totalAllItemQuantity;
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

    // @return base uri
    function getBaseUri() public view returns (string memory) {
        return _baseTokenURI;
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
