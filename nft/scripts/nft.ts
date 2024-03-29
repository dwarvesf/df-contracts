import hre from "hardhat";


async function main() {
    const owner = "0x44F2DBd5439Ecb438d5c9d4B72ECA417C5898FcB"
    const attributes = "0xa38b3fdBD9EfBdcf06921843dd88baB36d720f59"
    const name = "Dwarves"
    const symbol = "DF"
    const nfts = await hre.ethers.getContractFactory('Nft');

    const nft = await nfts.deploy(name, symbol, owner, attributes);
    await nft.waitForDeployment()
    console.log('NFT Contract Deployed at ' + nft.target);
    //0x7C7669d98EC544c2a4Fe06fB1deD1E250E0Bb032
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
