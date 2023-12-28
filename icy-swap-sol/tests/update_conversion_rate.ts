import * as anchor from "@project-serum/anchor";
import { Program } from "@project-serum/anchor";
import { IcySwapSol } from "../target/types/icy_swap_sol";
import { expect } from "chai";
import { TestValues, createValues, setupAdminAccount, sleep } from "./utils";
import {
  ASSOCIATED_TOKEN_PROGRAM_ID,
  TOKEN_PROGRAM_ID,
} from "@solana/spl-token";
import { SystemProgram } from "@solana/web3.js";
import { BN } from "bn.js";

describe("update conversion rate", () => {
  const provider = anchor.AnchorProvider.env();
  const connection = provider.connection;
  anchor.setProvider(provider);

  const program = anchor.workspace.IcySwapSol as Program<IcySwapSol>;

  let values: TestValues;

  beforeEach(async () => {
    values = createValues();
    await setupAdminAccount({
      connection,
      creator: values.admin,
      mintAKeypair: values.mintAKeypair,
      mintBKeypair: values.mintBKeypair,
      decimalA: values.decimalA,
      decimalB: values.decimalB,
    });

    await program.methods
      .createPool(1.5)
      .accounts({
        admin: values.admin.publicKey,
        pool: values.poolKey,
        poolAuthority: values.poolAuthority,
        mintA: values.mintAKeypair.publicKey,
        mintB: values.mintBKeypair.publicKey,
        poolAccountA: values.poolAccountA,
        poolAccountB: values.poolAccountB,
        tokenProgram: TOKEN_PROGRAM_ID,
        systemProgram: SystemProgram.programId,
        associatedTokenProgram: ASSOCIATED_TOKEN_PROGRAM_ID,
      })
      .signers([values.admin])
      .rpc({ skipPreflight: true });
  });

  it("Update conversion rate pool", async () => {
    await program.methods
      .updateConversionRate(2)
      .accounts({
        pool: values.poolKey,
        admin: values.admin.publicKey,
        mintA: values.mintAKeypair.publicKey,
        mintB: values.mintBKeypair.publicKey,
        systemProgram: SystemProgram.programId,
      })
      .signers([values.admin])
      .rpc({ skipPreflight: true });
    await sleep(3);
    const pool = await program.account.pool.fetch(values.poolKey);
    expect(pool.conversionRate, "check pool conversion rate a").to.equal(
      new BN(2).toNumber()
    );
  });
});
