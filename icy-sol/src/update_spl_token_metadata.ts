import { createUmi } from "@metaplex-foundation/umi-bundle-defaults"
import {
    createMetadataAccountV3,
    CreateMetadataAccountV3InstructionAccounts,
    CreateMetadataAccountV3InstructionArgs,
    DataV2Args
} from "@metaplex-foundation/mpl-token-metadata";
import { createSignerFromKeypair, signerIdentity, publicKey } from "@metaplex-foundation/umi";
import * as bs58 from "bs58";
import * as dotenv from "dotenv";
dotenv.config();

const mint_token = publicKey(process.env.MINT_TOKEN)

//Create a umi connection
const umi = createUmi(process.env.HELIUS_CONNECTION_DEVNET,);
const keypair = umi.eddsa.createKeypairFromSecretKey(bs58.decode(process.env.PRIVATE_KEY))
const signer = createSignerFromKeypair(umi, keypair);
umi.use(signerIdentity(createSignerFromKeypair(umi, keypair)));
(async () => {
    try {

        let accounts: CreateMetadataAccountV3InstructionAccounts = {
            mint: mint_token    ,
            mintAuthority: signer
        }

        let data: DataV2Args = {
            name: process.env.TOKEN_NAME,
            symbol: process.env.TOKEN_SYMBOL,
            uri: process.env.TOKEN_URI,
            sellerFeeBasisPoints: 0,
            collection: null,
            creators: null,
            uses: null
        }

        let args: CreateMetadataAccountV3InstructionArgs = {
            data,
            isMutable: true,
            collectionDetails: null,
        }

        const tx = createMetadataAccountV3(
            umi,
            {
                ...accounts,
                ...args,
            }
        )

        let result = await tx.sendAndConfirm(umi);

        console.log(`signature ${bs58.encode(result.signature)}`);
    } catch (e) {
        console.error(`Oops, something went wrong: ${e}`)
    }
})();
