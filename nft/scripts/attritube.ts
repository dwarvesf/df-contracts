import { ethers } from 'hardhat';

async function main() {
    const attributes = await ethers.deployContract('Attributes');

    await attributes.waitForDeployment();

    console.log('NFT Contract Deployed at ' + attributes.target);
    // 0xa38b3fdBD9EfBdcf06921843dd88baB36d720f59
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
