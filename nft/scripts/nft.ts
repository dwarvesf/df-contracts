import hre, { ethers } from "hardhat";


async function main() {
    const owner = "0x44F2DBd5439Ecb438d5c9d4B72ECA417C5898FcB"
    const attributes = "0x96326B0C701bC83D6FA815F2F2C9374C0B6D7258"
    const name = "Dwarves Foundation"
    const symbol = "DF"
    const nfts = await ethers.getContractFactory('Nft');

    const nft = await nfts.deploy(name, symbol, owner, attributes);
    await nft.waitForDeployment()
    console.log('NFT Contract Deployed at ' + nft.target);
    //0xc2FBBB7f68Afe47be2C32631682b065222d597b1
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
