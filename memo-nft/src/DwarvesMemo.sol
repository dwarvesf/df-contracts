// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract DwarvesMemo is
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

    /*//////////////////////////////////////////////////////////////
                                 STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    mapping(uint256 => string) private _arweaveTxIds; // Maps tokenId to Arweave transaction ID
    mapping(address => bool) private _uniqueMinters; // Tracks unique minters
    uint256 private _uniqueMinterCount; // Counts unique minters

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
    }

    /*//////////////////////////////////////////////////////////////
                                 ADMIN FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Creates a new NFT type mapped to an Arweave transaction ID.
     * @param tokenId The ID of the new NFT type.
     * @param arweaveTxId The Arweave transaction ID for the NFT metadata.
     */
    function createTokenType(uint256 tokenId, string memory arweaveTxId)
        external
        onlyOwner
    {
        require(
            bytes(_arweaveTxIds[tokenId]).length == 0,
            "Token ID already exists"
        );
        _arweaveTxIds[tokenId] = arweaveTxId;
        emit TokenTypeCreated(tokenId, arweaveTxId);
    }

    /**
     * @dev Updates the Arweave transaction ID for an existing token ID.
     * @param tokenId The ID of the NFT type to update.
     * @param newArweaveTxId The new Arweave transaction ID.
     */
    function updateTokenType(uint256 tokenId, string memory newArweaveTxId)
        external
        onlyOwner
    {
        require(
            bytes(_arweaveTxIds[tokenId]).length != 0,
            "Token ID does not exist"
        );
        _arweaveTxIds[tokenId] = newArweaveTxId;
        emit TokenTypeUpdated(tokenId, newArweaveTxId);
    }

    /*//////////////////////////////////////////////////////////////
                                 PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Returns the Arweave gateway URL for the token's metadata.
     * @param tokenId The ID of the NFT type.
     * @return The Arweave gateway URL.
     */
    function readNFT(uint256 tokenId) external view returns (string memory) {
        require(
            bytes(_arweaveTxIds[tokenId]).length != 0,
            "Token ID does not exist"
        );
        return
            string(
                abi.encodePacked(
                    "https://viewblock.io/arweave/tx/",
                    _arweaveTxIds[tokenId]
                )
            );
    }

    /**
     * @dev Mints tokens of an existing NFT type.
     * @param tokenId The ID of the NFT type to mint.
     * @param amount The number of tokens to mint.
     */
    function mintNFT(uint256 tokenId, uint256 amount) external {
        require(
            bytes(_arweaveTxIds[tokenId]).length != 0,
            "Token ID does not exist"
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
