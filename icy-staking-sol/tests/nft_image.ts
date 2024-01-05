import { createUmi } from "@metaplex-foundation/umi-bundle-defaults";
import { loadWallet } from "./utils";
import {
  createGenericFile,
  createSignerFromKeypair,
  signerIdentity,
} from "@metaplex-foundation/umi";
import { createBundlrUploader } from "@metaplex-foundation/umi-uploader-bundlr";
import { readFile } from "fs/promises";

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
    const content = await readFile("tests/9958.png");
    const image = createGenericFile(content, "9958.png");

    const [myUri] = await bundlrUploader.upload([image]);
    console.log("Your image URI: ", myUri);
  } catch (error) {
    console.log("Oops.. Something went wrong", error);
  }
})();
