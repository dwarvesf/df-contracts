import { createUmi } from "@metaplex-foundation/umi-bundle-defaults";
import {
  createSignerFromKeypair,
  signerIdentity,
  generateSigner,
  percentAmount,
  publicKey,
} from "@metaplex-foundation/umi";
import { loadWallet } from "./utils";
import {
  createNft,
  mplTokenMetadata,
} from "@metaplex-foundation/mpl-token-metadata";
import base58 from "bs58";

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
  let tx = createNft(umi, {
    mint: mint,
    authority: umi.identity,
    name: "Mad Lads #9958",
    symbol: "MAD",
    uri: "https://arweave.net/gcPPZZ6tlaQWP5cCnzS3JqnqqE_HxPITqCHY5hAJd00",
    collection: {
      verified: false,
      key: publicKey("EUxpDTQgADBmVodjGYGFiFqvMajxtFRv7fronfFe1KmT"),
    },
    sellerFeeBasisPoints: percentAmount(0),
    tokenOwner: publicKey("5v4DXdsXcPe9wrg98fZEHeY2DeamEyMAqLipj3du9ejU"),
  });

  let result = await tx.sendAndConfirm(umi);
  const signature = base58.encode(result.signature);

  console.log(
    `Succesfully Minted! Check out your TX here:\nhttps://explorer.solana.com/tx/${signature}?cluster=devnet`
  );

  console.log("Mint Address: ", mint.publicKey);
})();
