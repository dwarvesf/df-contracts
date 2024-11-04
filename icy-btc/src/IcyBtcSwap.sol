// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "solmate/auth/Owned.sol";
import "solmate/utils/ECDSA.sol";

contract IcyBtcSwap is Owned {
    address public signerAddress;

    event Swap(uint256 amount, string btcAddress, string btcAmount);
    event SetSigner(address signerAddress);

    fallback() external {
        revert();
    }

    receive() external payable {
        revert();
    }

    // =========================== VIEW FUNCTIONS ============================ //
    function getSigner(
        bytes32 _digest,
        bytes memory _signature
    ) public pure returns (address) {
        return ECDSA.recover(_digest, _signature);
    }

    // =========================== CALL FUNCTIONS ============================ //
    function setSigner(address _signerAddress) external onlyOwner {
        signerAddress = _signerAddress;
        emit SetSigner(signerAddress);
    }
}
