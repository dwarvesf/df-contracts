pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract Carrot is ERC20PresetFixedSupply {
    constructor()
        ERC20PresetFixedSupply(
            "Carrot Token",
            "CARROT",
            100000 * 10**decimals(),
            msg.sender
        )
    {}
}
