import * as anchor from "@project-serum/anchor";
import { Program } from "@project-serum/anchor";
import { IcySwapSol } from "../target/types/icy_swap_sol";
import { expect } from "chai";
import {
  TestValues,
  createValues,
  setupAdminAccount,
  airdropLamport,
  mintTokenA,
} from "./utils";
import {
  ASSOCIATED_TOKEN_PROGRAM_ID,
  TOKEN_PROGRAM_ID,
} from "@solana/spl-token";
import { SystemProgram } from "@solana/web3.js";
import { BN } from "bn.js";

describe("swap pool", () => {
  const provider = anchor.AnchorProvider.env();
  const connection = provider.connection;
  anchor.setProvider(provider);

  const program = anchor.workspace.IcySwapSol as Program<IcySwapSol>;

  let values: TestValues;

  const userTokenAAmount = 5;
  const conversionRate = 2;

  beforeEach(async () => {
    values = createValues();

    console.log("set up admin");
    await setupAdminAccount({
      connection,
      creator: values.admin,
      mintAKeypair: values.mintAKeypair,
      mintBKeypair: values.mintBKeypair,
    });

    console.log("airdrop lamport for user");
    await airdropLamport({
      connection,
      user: values.user,
    });

    console.log("mint token a for user");
    await mintTokenA({
      connection,
      creator: values.admin,
      user: values.user,
      mintAKeypair: values.mintAKeypair,
      mintedAmount: userTokenAAmount,
    });

    console.log("create pool");
    await program.methods
      .createPool(conversionRate)
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

    console.log("deposit token pool");
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

  it("swap token a", async () => {
    const userTokenABefore = await connection.getTokenAccountBalance(
      values.userAccountA
    );
    expect(
      userTokenABefore.value.amount,
      "check user token a before swap"
    ).to.equal((userTokenAAmount * 10 ** values.decimalA).toString());
    await program.methods
      .swapPool(values.swapAmountA)
      .accounts({
        pool: values.poolKey,
        poolAuthority: values.poolAuthority,
        user: values.user.publicKey,
        mintA: values.mintAKeypair.publicKey,
        mintB: values.mintBKeypair.publicKey,
        poolAccountA: values.poolAccountA,
        poolAccountB: values.poolAccountB,
        userAccountA: values.userAccountA,
        userAccountB: values.userAccountB,
        tokenProgram: TOKEN_PROGRAM_ID,
        systemProgram: SystemProgram.programId,
        associatedTokenProgram: ASSOCIATED_TOKEN_PROGRAM_ID,
      })
      .signers([values.user])
      .rpc({ skipPreflight: true });

    const userTokenAAfter = await connection.getTokenAccountBalance(
      values.userAccountA
    );
    expect(
      userTokenAAfter.value.amount,
      "check user token a before swap"
    ).to.equal(
      new BN(userTokenAAmount * 10 ** values.decimalA)
        .sub(values.swapAmountA)
        .toString()
    );

    const poolTokenAccountA = await connection.getTokenAccountBalance(
      values.poolAccountA
    );
    expect(poolTokenAccountA.value.amount, "check pool token a").to.equal(
      values.depositAmountA.add(values.swapAmountA).toString()
    );
    const userTokenAccountB = await connection.getTokenAccountBalance(
      values.userAccountB
    );
    expect(userTokenAccountB.value.amount, "check user token b").to.equal(
      new BN(200000000).toString()
    );
  });
});
