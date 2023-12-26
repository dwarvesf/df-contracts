import {getOrCreateAssociatedTokenAccount, mintTo} from "@solana/spl-token";
import {Commitment, Connection, Keypair, PublicKey} from "@solana/web3.js";
import * as bs58 from "bs58";
import * as path from "path";
import * as dotenv from "dotenv";
dotenv.config();


// Import our keypair owner keypair
const ownerWallet = Keypair.fromSecretKey(bs58.decode(process.env.PRIVATE_KEY));

// import airdrop wallet
const airdropWallet = new PublicKey(process.env.AIRDROP_WALLET)

// mint token
const mint_token = new PublicKey(process.env.MINT_TOKEN)

//Create a Solana devnet connection
const commitment: Commitment = "confirmed";
const connection = new Connection(process.env.HELIUS_CONNECTION_DEVNET, commitment);
const MINT_TOKEN_AMOUNT = Number(process.env.MINT_TOKEN_AMOUNT);

(async () => {
    try {
        // Create an ATA
        const ata = await getOrCreateAssociatedTokenAccount(connection, ownerWallet, mint_token, airdropWallet)
        console.log(`Your ata is: ${ata.address.toBase58()}`);

        // Mint to ATA
        const mintTx = await mintTo(connection, ownerWallet, mint_token, ata.address, ownerWallet, MINT_TOKEN_AMOUNT)
        console.log(`Your mint txid: ${mintTx}`);
    } catch (error) {
        console.log(`Oops, something went wrong: ${error}`)
    }
})()
