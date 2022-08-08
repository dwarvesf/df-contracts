require("dotenv").config();

const networks = {
  coverage: {
    url: "http://127.0.0.1:8555",
    blockGasLimit: 200000000,
    allowUnlimitedContractSize: true,
  },
  localhost: {
    chainId: 1,
    url: "http://127.0.0.1:8545",
    allowUnlimitedContractSize: true,
    timeout: 1000 * 60,
  },
  hardhat: {
    allowUnlimitedContractSize: true,
    chainId: 1337,
  },
};

if (process.env.PRIVATE_KEY) {
  networks.polygon = {
    accounts: [process.env.PRIVATE_KEY],
    chainId: 137,
    url: "https://polygon-rpc.com",
  };
  networks.ftm = {
    accounts: [process.env.PRIVATE_KEY],
    chainId: 250,
    // url: 'https://rpc.ankr.com/fantom/',
    url: "https://rpc.ftm.tools/",
  };
}

module.exports = networks;
