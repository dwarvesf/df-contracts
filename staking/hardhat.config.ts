import { HardhatUserConfig, task } from "hardhat/config";
import "@nomicfoundation/hardhat-verify";
import "@nomicfoundation/hardhat-toolbox";
import { HardhatRuntimeEnvironment, TaskArguments } from "hardhat/types";

require("dotenv").config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.24",
  },
  etherscan: {
    apiKey: {
      "base-sepolia": process.env.BASESCAN_API_KEY as string,
    },
    customChains: [
      {
        network: "base-sepolia",
        chainId: 84532,
        urls: {
          apiURL: "https://api-sepolia.basescan.org/api",
          browserURL: "https://sepolia.basescan.org",
        },
      },
    ],
  },
  networks: {
    // for mainnet
    "base-mainnet": {
      url: "https://mainnet.base.org",
      accounts: [process.env.WALLET_KEY as string],
      gasPrice: 1000000000,
    },
    // for testnet
    "base-sepolia": {
      url: "https://sepolia.base.org",
      accounts: [process.env.WALLET_KEY as string],
      gasPrice: 1000000000,
    },
    // for local dev environment
    "base-local": {
      url: "http://localhost:8545",
      accounts: [process.env.WALLET_KEY as string],
      gasPrice: 1000000000,
    },
  },
  defaultNetwork: "hardhat",
  // sourcify: { enabled: true },
};

// COMMAND: npx hardhat notifyRewardsAllPools --network base-sepolia
task("notifyRewardsAllPools", "Notify the rewards amount for all available pools")
  .setAction(async (_taskArgs: TaskArguments, hre: HardhatRuntimeEnvironment) => {
    const {ethers} = hre;
    const {DEPLOYER_ADDRESS, POOL_FACTORY_ADDRESS} = process.env;

    console.log(`execute [notifyRewardsAllPools] with params [${POOL_FACTORY_ADDRESS}]`);

    // Get a signer instance (adjust based on your network configuration)
    const signer = await ethers.getSigner(DEPLOYER_ADDRESS as string);
    const Factory = await ethers.getContractAt("StakingPoolFactory", POOL_FACTORY_ADDRESS as string, signer);
    
    // Initialize a transaction
    const tx = await Factory.connect(signer).notifyRewardAmounts();
    await tx.wait(); // Wait for the transaction to be mined
    console.log("Transaction hash:", tx.hash);
});

task("notifyRewardsSpecificPool", "Notify the rewards amount for a specific pool")
  .addParam("poolKey", "Key for a specific pool, in format: <staking_token>_<reward_token>")
  .addParam("rewardAmount", "Amount of reward token you want to provide to pool")
  .setAction(async (taskArgs: TaskArguments, hre: HardhatRuntimeEnvironment) => {
    const {ethers} = hre;
    const {poolKey, rewardAmount} = taskArgs;
    const {DEPLOYER_ADDRESS, POOL_FACTORY_ADDRESS} = process.env;

    console.log(`execute [notifyRewardsSpecificPool] with params [${POOL_FACTORY_ADDRESS}, ${poolKey}, ${rewardAmount}]`);

    // Get a signer instance (adjust based on your network configuration)
    const signer = await ethers.getSigner(DEPLOYER_ADDRESS as string);
    const Factory = await ethers.getContractAt("StakingPoolFactory", POOL_FACTORY_ADDRESS as string, signer);
    
    // Initialize a transaction
    const rewardAmountWithDecimal =  BigInt(rewardAmount);
    const tx = await Factory.connect(signer).notifyRewardAmount(poolKey, rewardAmountWithDecimal * 1000000000000000000n);
    await tx.wait(); // Wait for the transaction to be mined
    console.log("Transaction hash:", tx.hash);
});

export default config;
