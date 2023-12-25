import {createMint} from "@solana/spl-token";
import {Commitment, Connection, Keypair} from "@solana/web3.js";
import * as bs58 from "bs58";
import dotenv from "dotenv";
dotenv.config();


// Import our keypair from the wallet file
const ownerWallet = Keypair.fromSecretKey(bs58.decode(process.env.PRIVATE_KEY));

//Create a Solana devnet connection
const commitment: Commitment = "confirmed";
const connection = new Connection(process.env.HELIUS_CONNECTION_DEVNET, commitment);
const MINT_A_DECIMALS = Number(process.env.MINT_A_DECIMALS) || 10;

(async () => {
    try {
        let tokenMint = await createMint(
            connection, // conneciton
            ownerWallet, // fee payer
            ownerWallet.publicKey, // mint authority
            ownerWallet.publicKey, // freeze authority
            MINT_A_DECIMALS // decimals
        );
        console.log(`token mint: ${tokenMint}`)
    } catch (error) {
        console.log(`Oops, something went wrong: ${error}`)
    }
})()
