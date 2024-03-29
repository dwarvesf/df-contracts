import hre, { ethers } from "hardhat";


async function main() {
    const owner = "0x44F2DBd5439Ecb438d5c9d4B72ECA417C5898FcB"
    const attributes = "0x5cFe1538bAd0a4835A8DE936246CC9960E91D209"
    const name = "Dwarves Foundation"
    const symbol = "DF"
    const nfts = await ethers.getContractFactory('Nft');

    const nft = await nfts.deploy(name, symbol, owner, attributes);
    await nft.waitForDeployment()
    console.log('NFT Contract Deployed at ' + nft.target);
    //0xb52c1e15815268beBe55A6C8CAC886831FD75cdA
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
