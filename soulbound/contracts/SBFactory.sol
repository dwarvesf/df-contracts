// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./soulbound.sol";

contract SBFactory {
  int public soulboundCount;
  Soulbound[] public soulbounds;

  event NewSoulbound(address indexed soulbound, string name, string symbol);

  function createSoulbound(
      string memory name,
      string memory symbol,
      address initialOwner
  ) public {
      Soulbound soulbound = new Soulbound(name, symbol, initialOwner);
      soulbounds.push(soulbound);
      soulboundCount++;
      emit NewSoulbound(address(soulbound), name, symbol);
  }
}
