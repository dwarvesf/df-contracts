import hre, { ethers } from "hardhat";


async function main() {
    const owner = "0x44F2DBd5439Ecb438d5c9d4B72ECA417C5898FcB"
    const attributes = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512"
    const name = "Dwarves Foundation"
    const symbol = "DF"
    const nfts = await ethers.getContractFactory('Nft');

    const nft = await nfts.deploy(name, symbol, owner, attributes);
    await nft.waitForDeployment()
    console.log('NFT Contract Deployed at ' + nft.target);
    //0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
