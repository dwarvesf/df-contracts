// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract DwarvesMemo is
    Initializable,
    ERC1155Upgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event TokenTypeCreated(uint256 indexed tokenId, string arweaveTxId);
    event TokenTypeUpdated(uint256 indexed tokenId, string newArweaveTxId);
    event TokenMinted(
        address indexed to,
        uint256 indexed tokenId,
        uint256 amount
    );
    event ArweaveGatewayUrlUpdated(string newArweaveGatewayUrl);

    /*//////////////////////////////////////////////////////////////
                                 STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    string public _arweaveGatewayUrl; // The Arweave gateway URL
    mapping(string => uint256) private _arweaveTxIdToTokenId; // Maps Arweave transaction ID to tokenId
    mapping(uint256 => string) private _tokenIdToArweaveTxId; // Maps tokenId to Arweave transaction ID
    mapping(address => bool) private _uniqueMinters; // Tracks unique minters
    uint256 private _uniqueMinterCount; // Counts unique minters
    uint256 private _nextTokenId; // Auto-incrementing token ID counter

    /*//////////////////////////////////////////////////////////////
                                 CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers(); // Disables initializer on implementation contract
    }

    /**
     * @dev Initializes the contract (replaces constructor for upgradeable contracts).
     * @param uri The base URI for the ERC1155 token.
     */
    function initialize(string memory uri) public initializer {
        __ERC1155_init(uri);
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

        // Initialize state variables
        _nextTokenId = 1;
        _arweaveGatewayUrl = "https://arweave.developerdao.com/";
    }


    /*//////////////////////////////////////////////////////////////
                                 ADMIN FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function setArweaveGatewayUrl(string memory newArweaveGatewayUrl)
        external
        onlyOwner
    {
        _arweaveGatewayUrl = newArweaveGatewayUrl;
        emit ArweaveGatewayUrlUpdated(newArweaveGatewayUrl);
    }

    /**
     * @dev Creates a new NFT type based on an Arweave transaction ID.
     * @param arweaveTxId The Arweave transaction ID for the NFT metadata.
     * @return The automatically assigned token ID.
     */
    function createTokenType(string memory arweaveTxId)
        external
        onlyOwner
        returns (uint256)
    {
        require(
            bytes(arweaveTxId).length > 0,
            "Arweave transaction ID cannot be empty"
        );
        require(
            _arweaveTxIdToTokenId[arweaveTxId] == 0,
            "Arweave transaction ID already in use"
        );
        
        uint256 tokenId = _nextTokenId++;
        _tokenIdToArweaveTxId[tokenId] = arweaveTxId;
        _arweaveTxIdToTokenId[arweaveTxId] = tokenId;
        
        emit TokenTypeCreated(tokenId, arweaveTxId);
        return tokenId;
    }

    /**
     * @dev Updates the Arweave transaction ID for an existing token ID.
     * @param tokenId The token ID to update.
     * @param newArweaveTxId The new Arweave transaction ID.
     */
    function updateTokenType(uint256 tokenId, string memory newArweaveTxId)
        external
        onlyOwner
    {
        require(
            bytes(newArweaveTxId).length > 0,
            "Arweave transaction ID cannot be empty"
        );
        string memory oldArweaveTxId = _tokenIdToArweaveTxId[tokenId];
        require(
            bytes(oldArweaveTxId).length > 0,
            "Token type does not exist"
        );
        require(
            _arweaveTxIdToTokenId[newArweaveTxId] == 0,
            "New Arweave transaction ID already in use"
        );
        
        // Update mappings
        _arweaveTxIdToTokenId[oldArweaveTxId] = 0;
        _tokenIdToArweaveTxId[tokenId] = newArweaveTxId;
        _arweaveTxIdToTokenId[newArweaveTxId] = tokenId;
        
        emit TokenTypeUpdated(tokenId, newArweaveTxId);
    }

    /*//////////////////////////////////////////////////////////////
                                 PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Returns the Arweave gateway URL for the token's metadata.
     * @param tokenId The token ID.
     * @return The Arweave gateway URL.
     */
    function readNFT(uint256 tokenId) external view returns (string memory) {
        string memory arweaveTxId = _tokenIdToArweaveTxId[tokenId];
        require(
            bytes(arweaveTxId).length > 0,
            "Token type does not exist"
        );
        return
            string(
                abi.encodePacked(
                    _arweaveGatewayUrl,
                    arweaveTxId
                )
            );
    }

    /**
     * @dev Returns the token ID for a given Arweave transaction ID.
     * @param arweaveTxId The Arweave transaction ID.
     * @return The corresponding token ID.
     */
    function getTokenId(string memory arweaveTxId) external view returns (uint256) {
        uint256 tokenId = _arweaveTxIdToTokenId[arweaveTxId];
        require(tokenId != 0, "Token type does not exist");
        return tokenId;
    }

    /**
     * @dev Mints tokens of an existing NFT type.
     * @param tokenId The token ID of the NFT type to mint.
     * @param amount The number of tokens to mint.
     */
    function mintNFT(uint256 tokenId, uint256 amount) external {
        require(
            bytes(_tokenIdToArweaveTxId[tokenId]).length > 0,
            "Token type does not exist"
        );
        _mint(msg.sender, tokenId, amount, "");

        // Track unique minters
        if (!_uniqueMinters[msg.sender]) {
            _uniqueMinters[msg.sender] = true;
            _uniqueMinterCount++;
        }

        emit TokenMinted(msg.sender, tokenId, amount);
    }

    /**
     * @dev Returns the total number of unique addresses that have minted at least one NFT.
     * @return The count of unique minters.
     */
    function getUniqueMinterCount() external view returns (uint256) {
        return _uniqueMinterCount;
    }

    /*//////////////////////////////////////////////////////////////
                                 UUPS UPGRADE AUTHORIZATION
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Override to restrict upgrades to the owner.
     */
    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}
}
