import { ethers } from 'hardhat';

async function main() {
    const attributes = await ethers.deployContract('Attributes');

    await attributes.waitForDeployment();

    console.log('NFT Contract Deployed at ' + attributes.target);
    // 0x5cFe1538bAd0a4835A8DE936246CC9960E91D209
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
