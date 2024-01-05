import { createUmi } from "@metaplex-foundation/umi-bundle-defaults";
import {
  createSignerFromKeypair,
  signerIdentity,
  generateSigner,
  publicKey,
} from "@metaplex-foundation/umi";
import { loadWallet } from "./utils";
import {
  findMasterEditionPda, findMetadataPda,
  mplTokenMetadata,
  verifyCollectionV1,
} from "@metaplex-foundation/mpl-token-metadata";
import base58 from "bs58";
import {Context} from "mocha";

// Create a UMI connection
const umi = createUmi(
  "https://devnet.helius-rpc.com/?api-key=0ff42e79-adbe-4960-b137-de8fea38bd19"
).use(mplTokenMetadata());
const secretWallet = loadWallet("wallet.json");
const keypair = umi.eddsa.createKeypairFromSecretKey(
  new Uint8Array(secretWallet)
);

const signer = createSignerFromKeypair(umi, keypair);
umi.use(signerIdentity(createSignerFromKeypair(umi, keypair)));

const mint = generateSigner(umi);

(async () => {
  const collectionMintAddress = "EUxpDTQgADBmVodjGYGFiFqvMajxtFRv7fronfFe1KmT"
  const nftMintAddress = "H5KAbC9adLDsauuhc1BPd8MBz4pNRRF6U3D2Tnb3SXuE"
  const collectionMasterEdition = findMasterEditionPda(umi, {mint: publicKey(collectionMintAddress)})
  const collectionMetadata = findMetadataPda(umi, {mint: publicKey(collectionMintAddress)})
  const nftMetadata = findMetadataPda(umi, {mint: publicKey(nftMintAddress)})

  let tx = verifyCollectionV1(umi, {
    collectionMint: publicKey("EUxpDTQgADBmVodjGYGFiFqvMajxtFRv7fronfFe1KmT"),
    metadata: publicKey(nftMetadata[0]),
    collectionMasterEdition: publicKey(
      collectionMasterEdition[0]
    ),
    authority: signer,
    collectionMetadata: publicKey(
        collectionMetadata[0]
    ),
  });

  let result = await tx.sendAndConfirm(umi);
  const signature = base58.encode(result.signature);

  console.log(
    `Succesfully verify! Check out your TX here:\nhttps://explorer.solana.com/tx/${signature}?cluster=devnet`
  );

  console.log("Mint Address: ", mint.publicKey);
})();
