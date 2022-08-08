const hre = require("hardhat");

async function main() {
  const Carrot = await hre.ethers.getContractFactory("Carrot");
  const instance = await Carrot.deploy();
  await instance.deployed();

  console.log("carrot deployed to:", instance.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
