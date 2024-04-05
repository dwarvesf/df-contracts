require("@nomicfoundation/hardhat-toolbox");
const { vars } = require("hardhat/config");

const PRIVATE_KEY = vars.get("PRIVATE_KEY");
const ETHERSCAN_API_KEY = vars.get("ETHERSCAN_API_KEY");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    base: {
      url: "https://base-mainnet.g.alchemy.com/v2/i3masvvs6gsvF11qhLbS6guwihL5G1lz",
      accounts: [PRIVATE_KEY],
      gasPrice: 1000000000,

    },
    basesepolia: {
      url: "https://sepolia.base.org",
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      base: ETHERSCAN_API_KEY,
    }
  },
};
