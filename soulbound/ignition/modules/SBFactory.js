const {buildModule} = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("SBFactory", (m) => {
  const sbfactory = m.contract("SBFactory",[]);
  return { sbfactory };
});
