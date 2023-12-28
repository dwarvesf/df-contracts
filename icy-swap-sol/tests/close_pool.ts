import * as anchor from "@project-serum/anchor";
import { Program } from "@project-serum/anchor";
import { IcySwapSol } from "../target/types/icy_swap_sol";
import { expect } from "chai";
import { TestValues, createValues, setupAdminAccount } from "./utils";
import {
  ASSOCIATED_TOKEN_PROGRAM_ID,
  TOKEN_PROGRAM_ID,
} from "@solana/spl-token";
import { SystemProgram } from "@solana/web3.js";
import { BN } from "bn.js";

describe("close pool", () => {
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

    await program.methods
      .depositPool(values.depositAmountA, values.depositAmountB)
      .accounts({
        pool: values.poolKey,
        poolAuthority: values.poolAuthority,
        admin: values.admin.publicKey,
        mintA: values.mintAKeypair.publicKey,
        mintB: values.mintBKeypair.publicKey,
        poolAccountA: values.poolAccountA,
        poolAccountB: values.poolAccountB,
        adminAccountA: values.adminAccountA,
        adminAccountB: values.adminAccountB,
        tokenProgram: TOKEN_PROGRAM_ID,
        systemProgram: SystemProgram.programId,
        associatedTokenProgram: ASSOCIATED_TOKEN_PROGRAM_ID,
      })
      .signers([values.admin])
      .rpc({ skipPreflight: true });
  });

  it("close pool", async () => {
    const adminAccountABefore = await connection.getTokenAccountBalance(
      values.adminAccountA
    );
    const adminAccountBBefore = await connection.getTokenAccountBalance(
      values.adminAccountB
    );
    await program.methods
      .closePool()
      .accounts({
        pool: values.poolKey,
        poolAuthority: values.poolAuthority,
        admin: values.admin.publicKey,
        mintA: values.mintAKeypair.publicKey,
        mintB: values.mintBKeypair.publicKey,
        poolAccountA: values.poolAccountA,
        poolAccountB: values.poolAccountB,
        adminAccountA: values.adminAccountA,
        adminAccountB: values.adminAccountB,
        tokenProgram: TOKEN_PROGRAM_ID,
        systemProgram: SystemProgram.programId,
        associatedTokenProgram: ASSOCIATED_TOKEN_PROGRAM_ID,
      })
      .signers([values.admin])
      .rpc({ skipPreflight: true });

    const adminAccountAAfter = await connection.getTokenAccountBalance(
      values.adminAccountA
    );
    expect(adminAccountAAfter.value.amount, "check admin token a").to.equal(
      values.depositAmountA
        .add(new BN(adminAccountABefore.value.amount))
        .toString()
    );
    const adminAccountBAfter = await connection.getTokenAccountBalance(
      values.adminAccountB
    );
    expect(adminAccountBAfter.value.amount, "check admin token b").to.equal(
      values.depositAmountB
        .add(new BN(adminAccountBBefore.value.amount))
        .toString()
    );
  });
});
