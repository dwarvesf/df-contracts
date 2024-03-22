import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const INITIAL_ONWER = "0x030c5a66341c0EDdC771F7aae79ABCA58aDE4c91"; // replace with deployer address
const STAKING_POOL_GENESIS = Math.floor((Date.now() + 2 * 60 * 1000) / 1000); // block time at which the contract is deployed
console.log("deploy timestamp: ", STAKING_POOL_GENESIS);

const StakingPoolFactoryModule = buildModule("StakingPoolFactory", (m) => {
  const initialOwner = m.getParameter("initialOwner", INITIAL_ONWER);
  const stakingPoolGenesis = m.getParameter("stakingPoolGenesis", STAKING_POOL_GENESIS);

  const stakingPoolFactory = m.contract("StakingPoolFactory", [stakingPoolGenesis, initialOwner])

  return { stakingPoolFactory };
})

export default StakingPoolFactoryModule;