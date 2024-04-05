const hre = require("hardhat");
const { ethers } = hre;

async function main() {
  console.log(`deploying SBFactory contract...`);
  const Factory = await ethers.getContractFactory("SBFactory");
  const factory = await Factory.deploy();
  await factory.waitForDeployment()

  console.log(`factory deployed to ${factory.address}`);

  console.log(`verifying contract...`);
  await hre
    .run("verify:verify", {
      address: factory.address,
    })
    .then(() => {
      console.log(`contract verified success`);
    })
    .catch((e) => {
      console.log(`contract verify failed ${e}`);
    });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
