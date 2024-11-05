// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "solmate/auth/Owned.sol";
import "solmate/tokens/ERC20.sol";
import "solmate/utils/SafeTransferLib.sol";
import "solady/utils/ECDSA.sol";
import "solady/utils/EIP712.sol";

contract IcyBtcSwap is Owned, EIP712 {
    using SafeTransferLib for ERC20;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Swap(uint256 icyAmount, string btcAddress, uint256 btcAmount);
    event RevertIcy(uint256 icyAmount, string btcAddress, uint256 btcAmount);
    event SetSigner(address signerAddress);

    /*//////////////////////////////////////////////////////////////
                                 CONSTANTS
    //////////////////////////////////////////////////////////////*/

    bytes32 public constant SWAP_HASH =
        keccak256(
            "Swap(uint256 icyAmount,string btcAddress,uint256 btcAmountuint256 deadline)"
        );

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    address public signerAddress;
    ERC20 public icy;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(ERC20 _icy) Owned(msg.sender) {
        signerAddress = msg.sender;
        icy = _icy;
    }

    function swap(
        uint256 icyAmount,
        string memory btcAddress,
        uint256 btcAmount,
        uint256 deadline,
        bytes memory _signature
    ) external {
        // 1.0 Check daedline is excceded
        require(block.timestamp <= deadline, "EXCEEDED_DEADLINE");

        // 2.0 Check valid signer
        bytes32 swapHash = getSwapHash(
            icyAmount,
            btcAddress,
            btcAmount,
            deadline
        );
        address signer = getSigner(swapHash, _signature);
        require(signer == signerAddress, "INVALID_SIGNER");

        // 3.0 burn icy: by basically transfer icy to this contract
        icy.safeTransferFrom(msg.sender, address(this), icyAmount);

        // 4.0 emit swap event
        emit Swap(icyAmount, btcAddress, btcAmount);
    }

    function revertIcy(
        uint256 icyAmount,
        string memory btcAddress,
        uint256 btcAmount,
        uint256 deadline,
        bytes memory _signature
    ) external {
        bytes32 swapHash = getSwapHash(
            icyAmount,
            btcAddress,
            btcAmount,
            deadline
        );
        address signer = getSigner(swapHash, _signature);
        require(signer == signerAddress, "INVALID_SIGNER");

        // revert icy
        icy.safeTransfer(msg.sender, icyAmount);

        // emit swap event
        emit RevertIcy(icyAmount, btcAddress, btcAmount);
    }

    /*//////////////////////////////////////////////////////////////
                               SIGNER MANAGE
    //////////////////////////////////////////////////////////////*/

    function getSigner(
        bytes32 _digest,
        bytes memory _signature
    ) public view returns (address) {
        return ECDSA.recover(_digest, _signature);
    }

    function setSigner(address _signerAddress) external onlyOwner {
        signerAddress = _signerAddress;
        emit SetSigner(signerAddress);
    }

    function getSwapHash(
        uint256 icyAmount,
        string memory btcAddress,
        uint256 btcAmount,
        uint256 deadline
    ) public view returns (bytes32 hash) {
        hash = _hashTypedData(
            keccak256(
                abi.encode(
                    SWAP_HASH,
                    icyAmount,
                    btcAddress,
                    btcAmount,
                    deadline
                )
            )
        );
    }

    function _domainNameAndVersion()
        internal
        pure
        override
        returns (string memory name, string memory version)
    {
        name = "ICY BTC SWAP";
        version = "1";
    }

    fallback() external {
        revert();
    }

    receive() external payable {
        revert();
    }
}
