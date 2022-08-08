const hre = require("hardhat");

async function main() {
  const Icy = await hre.ethers.getContractFactory("Icy");
  const instance = await Icy.deploy();
  await instance.deployed();

  console.log("Icy deployed to:", instance.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
