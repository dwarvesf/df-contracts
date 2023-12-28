import * as anchor from "@project-serum/anchor";
import {
  createMint,
  getAssociatedTokenAddressSync,
  getOrCreateAssociatedTokenAccount,
  mintTo,
} from "@solana/spl-token";
import {
  Keypair,
  PublicKey,
  Connection,
  Signer,
  LAMPORTS_PER_SOL,
} from "@solana/web3.js";
import { BN } from "bn.js";

export async function sleep(seconds: number) {
  new Promise((resolve) => setTimeout(resolve, seconds * 1000));
}

export const TokenDecimalA = 6;
export const TokenDecimalB = 8;

export const generateSeededKeypair = (seed: string) => {
  return Keypair.fromSeed(
    anchor.utils.bytes.utf8.encode(anchor.utils.sha256.hash(seed)).slice(0, 32)
  );
};

export const mintTokenA = async ({
  connection,
  creator,
  user,
  mintAKeypair,
  mintedAmount = 5,
  decimalA = TokenDecimalA,
}: {
  connection: Connection;
  creator: Signer;
  user: Signer;
  mintAKeypair: Keypair;
  mintedAmount?: number;
  decimalA?: number;
}) => {
  await getOrCreateAssociatedTokenAccount(
    connection,
    creator,
    mintAKeypair.publicKey,
    user.publicKey,
    true
  );
  await mintTo(
    connection,
    creator,
    mintAKeypair.publicKey,
    getAssociatedTokenAddressSync(mintAKeypair.publicKey, user.publicKey, true),
    creator.publicKey,
    mintedAmount * 10 ** decimalA
  );
};

export const mintTokenB = async ({
  connection,
  creator,
  user,
  mintAKeypair,
  mintedAmount = 5,
  decimalB = TokenDecimalB,
}: {
  connection: Connection;
  creator: Signer;
  user: Signer;
  mintAKeypair: Keypair;
  mintedAmount?: number;
  decimalB?: number;
}) => {
  await getOrCreateAssociatedTokenAccount(
    connection,
    creator,
    mintAKeypair.publicKey,
    user.publicKey,
    true
  );
  await mintTo(
    connection,
    creator,
    mintAKeypair.publicKey,
    getAssociatedTokenAddressSync(mintAKeypair.publicKey, user.publicKey, true),
    creator.publicKey,
    mintedAmount * 10 ** decimalB
  );
};

export const airdropLamport = async ({
  connection,
  user,
}: {
  connection: Connection;
  user: Signer;
}) => {
  await connection.confirmTransaction(
    await connection.requestAirdrop(user.publicKey, 2 * LAMPORTS_PER_SOL)
  );
};

export const setupAdminAccount = async ({
  connection,
  creator,
  mintAKeypair,
  mintBKeypair,
  mintedAmount = 100,
  decimalA = TokenDecimalA,
  decimalB = TokenDecimalB,
}: {
  connection: Connection;
  creator: Signer;
  holder?: Signer;
  mintAKeypair: Keypair;
  mintBKeypair: Keypair;
  mintedAmount?: number;
  decimalA?: number;
  decimalB?: number;
}) => {
  // Mint tokens
  await connection.confirmTransaction(
    await connection.requestAirdrop(creator.publicKey, 2 * LAMPORTS_PER_SOL)
  );
  await createMint(
    connection,
    creator,
    creator.publicKey,
    creator.publicKey,
    decimalA,
    mintAKeypair
  );
  await createMint(
    connection,
    creator,
    creator.publicKey,
    creator.publicKey,
    decimalB,
    mintBKeypair
  );
  await getOrCreateAssociatedTokenAccount(
    connection,
    creator,
    mintAKeypair.publicKey,
    creator.publicKey,
    true
  );
  await getOrCreateAssociatedTokenAccount(
    connection,
    creator,
    mintBKeypair.publicKey,
    creator.publicKey,
    true
  );
  await mintTo(
    connection,
    creator,
    mintAKeypair.publicKey,
    getAssociatedTokenAddressSync(
      mintAKeypair.publicKey,
      creator.publicKey,
      true
    ),
    creator.publicKey,
    mintedAmount * 10 ** decimalA
  );
  await mintTo(
    connection,
    creator,
    mintBKeypair.publicKey,
    getAssociatedTokenAddressSync(
      mintBKeypair.publicKey,
      creator.publicKey,
      true
    ),
    creator.publicKey,
    mintedAmount * 10 ** decimalB
  );
};

export interface TestValues {
  id: PublicKey;
  admin: Keypair;
  user: Keypair;
  mintAKeypair: Keypair;
  mintBKeypair: Keypair;
  poolKey: PublicKey;
  poolAuthority: PublicKey;
  depositAmountA: anchor.BN;
  depositAmountB: anchor.BN;
  withdrawAmountA: anchor.BN;
  withdrawAmountB: anchor.BN;
  swapAmountA: anchor.BN;
  poolAccountA: PublicKey;
  poolAccountB: PublicKey;
  adminAccountA: PublicKey;
  adminAccountB: PublicKey;
  userAccountA: PublicKey;
  userAccountB: PublicKey;
  decimalA: number;
  decimalB: number;
}

type TestValuesDefaults = {
  [K in keyof TestValues]+?: TestValues[K];
};
export function createValues(defaults?: TestValuesDefaults): TestValues {
  const id = Keypair.generate().publicKey;
  const admin = Keypair.generate();
  const user = Keypair.generate();

  // Making sure tokens are in the right order
  const mintAKeypair = Keypair.generate();
  let mintBKeypair = Keypair.generate();
  while (
    new BN(mintBKeypair.publicKey.toBytes()).lt(
      new BN(mintAKeypair.publicKey.toBytes())
    )
  ) {
    mintBKeypair = Keypair.generate();
  }

  const poolAuthority = PublicKey.findProgramAddressSync(
    [
      admin.publicKey.toBuffer(),
      mintAKeypair.publicKey.toBuffer(),
      mintBKeypair.publicKey.toBuffer(),
      Buffer.from("authority"),
    ],
    anchor.workspace.IcySwapSol.programId
  )[0];
  const poolKey = PublicKey.findProgramAddressSync(
    [
      admin.publicKey.toBuffer(),
      mintAKeypair.publicKey.toBuffer(),
      mintBKeypair.publicKey.toBuffer(),
      Buffer.from("pool"),
    ],
    anchor.workspace.IcySwapSol.programId
  )[0];
  return {
    id,
    admin,
    user,
    mintAKeypair,
    mintBKeypair,
    poolKey,
    poolAuthority,
    poolAccountA: getAssociatedTokenAddressSync(
      mintAKeypair.publicKey,
      poolAuthority,
      true
    ),
    poolAccountB: getAssociatedTokenAddressSync(
      mintBKeypair.publicKey,
      poolAuthority,
      true
    ),
    adminAccountA: getAssociatedTokenAddressSync(
      mintAKeypair.publicKey,
      admin.publicKey,
      true
    ),
    adminAccountB: getAssociatedTokenAddressSync(
      mintBKeypair.publicKey,
      admin.publicKey,
      true
    ),
    userAccountA: getAssociatedTokenAddressSync(
      mintAKeypair.publicKey,
      user.publicKey,
      true
    ),
    userAccountB: getAssociatedTokenAddressSync(
      mintBKeypair.publicKey,
      user.publicKey,
      true
    ),
    depositAmountA: new BN(10 * 10 ** TokenDecimalA),
    depositAmountB: new BN(10 * 10 ** TokenDecimalB),
    withdrawAmountA: new BN(2 * 10 ** TokenDecimalA),
    withdrawAmountB: new BN(2 * 10 ** TokenDecimalB),
    swapAmountA: new BN(10 ** TokenDecimalA),
    decimalA: TokenDecimalA,
    decimalB: TokenDecimalB,
  };
}
