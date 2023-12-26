pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract Icy is ERC20PresetFixedSupply {
    constructor()
        ERC20PresetFixedSupply(
            "Icy Token",
            "ICY",
            100000 * 10**decimals(),
            msg.sender
        )
    {}
}
