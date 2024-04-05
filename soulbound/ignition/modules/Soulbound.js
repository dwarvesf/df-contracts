const {buildModule} = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("Soulbound", (m) => {
  const name = m.getParameter("name", "DF Community JPEG")
  const symbol = m.getParameter("symbol", "DFCJ")
  const owner = m.getParameter("owner", "0x2F8E036baE50E25343BF503562C020EF6DAD4dCF");

  const soulbound = m.contract("Soulbound",[name, symbol, owner]);

  return { soulbound };
});
