import { ethers } from 'hardhat';

async function main() {
    const attributes = await ethers.deployContract('Attributes');

    await attributes.waitForDeployment();

    console.log('NFT Contract Deployed at ' + attributes.target);
    //0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
