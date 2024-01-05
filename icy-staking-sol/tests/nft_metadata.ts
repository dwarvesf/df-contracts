import { createUmi } from "@metaplex-foundation/umi-bundle-defaults";
import {
  createSignerFromKeypair,
  signerIdentity,
} from "@metaplex-foundation/umi";
import { createBundlrUploader } from "@metaplex-foundation/umi-uploader-bundlr";
import { loadWallet } from "./utils";

// Create a devnet connection
const umi = createUmi(
  "https://devnet.helius-rpc.com/?api-key=0ff42e79-adbe-4960-b137-de8fea38bd19"
);
const secretWallet = loadWallet("wallet.json");
const keypair = umi.eddsa.createKeypairFromSecretKey(
  new Uint8Array(secretWallet)
);

const bundlrUploader = createBundlrUploader(umi);

const signer = createSignerFromKeypair(umi, keypair);

umi.use(signerIdentity(signer));

(async () => {
  try {
    // Follow this JSON structure
    // https://docs.metaplex.com/programs/token-metadata/changelog/v1.0#json-structure

    const image: string =
      "https://arweave.net/PwD0sQJIuWLB2YN5JZBSa3appmnZ8mqrqWfKdR_kPE8";

    const metadata = {
      name: "Mad Lads #9958",
      symbol: "MAD",
      description: "Fock it",
      image: image,
      attributes: [
        {
          trait_type: "Gender",
          value: "Male",
        },
        {
          trait_type: "Type",
          value: "Light",
        },
        {
          trait_type: "Expression",
          value: "Joy",
        },
        {
          trait_type: "Hair",
          value: "Punk",
        },
        {
          trait_type: "Eyes",
          value: "Closed",
        },
        {
          trait_type: "Clothing",
          value: "Winter Battlegear",
        },
        {
          trait_type: "Background",
          value: "Pink",
        },
      ],
      properties: {
        files: [
          {
            type: "image/png",
            uri: image,
          },
        ],
      },
      creators: [],
    };

    const myUri = await bundlrUploader.uploadJson(metadata);
    console.log("Your metadate URI: ", myUri);
  } catch (error) {
    console.log("Oops.. Something went wrong", error);
  }
})();
