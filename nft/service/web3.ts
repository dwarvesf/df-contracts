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

export const listTokenIdOfWallet = async (wallet: string) => {
    let listTokenId = [];

    const totalTokenSupply = await nftContract.totalMaxSupplyOfToken();

    for (let id = 1; id <= Number(totalTokenSupply.toString()); id ++) {
        const owner = await nftContract.ownerOf(id)
        if (owner.toString() == wallet) {
            listTokenId.push(id)
        }
    }

    return listTokenId
}

export const mintNft = async (wallet: string, luckyPoint: number) => {
    const txs = await nftContract.mint(wallet, luckyPoint)

    return txs
}

async function main() {
    console.log(await getTokenUri(1));
    const attribute = await getTokenAttribue(1)
    console.log(attribute.tier.toString())
    console.log(await listTokenIdOfWallet("0x4823212352eD675Db7025EAB79f7a6e119011732"));
    console.log(await mintNft("0x4823212352eD675Db7025EAB79f7a6e119011732", 100))
    //0xb52c1e15815268beBe55A6C8CAC886831FD75cdA
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
