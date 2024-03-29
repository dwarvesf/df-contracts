import { ethers } from "ethers";
import {
    Nft,
    Nft__factory,
} from "../abi/types";

require('dotenv').config();

const BASE_PROVIDER_RPC = process.env.BASE_PROVIDER_RPC as string;
const DEPLOYER_WALLET_KEY = process.env.WALLET_KEY as string;
const NFT_ADDRESS = process.env.NFT_ADDRESS as string;

// connect to Base RPC Provider
const provider = new ethers.JsonRpcProvider(BASE_PROVIDER_RPC);
const deployerSigner = new ethers.Wallet(DEPLOYER_WALLET_KEY, provider);

// instantiate StakingPoolFactory contract
const nftContract = Nft__factory.connect(
    NFT_ADDRESS,
    deployerSigner
);

// TODO: implement formula to calculate realtime APR
export const getTokenUri = async (tokenId: number) => {
    return nftContract.tokenURI(tokenId);
}

export const getTokenAttribue = async (tokenId: number) => {
    return nftContract.getTokenAttribute(tokenId);
}

async function main() {
    console.log(await getTokenUri(1));
    const attribute = await getTokenAttribue(1)
    console.log(attribute.tier.toString())
    //0xb52c1e15815268beBe55A6C8CAC886831FD75cdA
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
