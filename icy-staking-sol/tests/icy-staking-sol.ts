import * as anchor from "@coral-xyz/anchor";
import { Program, web3 } from "@coral-xyz/anchor";
import { IcyStakingSol } from "../target/types/icy_staking_sol";
import { PublicKey } from "@solana/web3.js";
import { loadWallet } from "./utils";
import * as token from "@solana/spl-token";
import BN from "bn.js";
import {getOrCreateAssociatedTokenAccount} from "@solana/spl-token";

//constants
const collectionAddress = new PublicKey(
  "EUxpDTQgADBmVodjGYGFiFqvMajxtFRv7fronfFe1KmT"
); // Mint Address of the Collection NFT for which the staking to be activated
const rewardMint = new PublicKey(
  "5B2TabGvtPgV67jnyEhhSrFvTTBv4awdrPg2qxNashhm"
); // Mint of the Token to be given as reward
const rewardTokenDeciaml = 5;
// Token account for the reward token
const creatorRewardTokenAccount = new PublicKey(
  "2GAqjSTKJxEqQxc3718GZbhbDWCujzQexZ4VjR7SSia7"
);
// NFT of the collection - must be owned by the Signer
const userNftMint = new PublicKey(
  "H5KAbC9adLDsauuhc1BPd8MBz4pNRRF6U3D2Tnb3SXuE"
);
const userNftTokenAccount = new PublicKey(
  "8o7mVYwWhis32Q6PC13nngRfSgP8vJRDjUEMH15eReva"
);
const userNftMetadata = new PublicKey(
  "9VDULdkVwzceAWSQWUb5LXczLzKH4joijQdZoQgnAXuB"
);
const userNftEdition = new PublicKey(
  "Fv9EjxbdcDvro8QmLqDZw6zHAwjqdogKNz4nDdEYV1aK"
);

describe("icy-staking-sol", () => {
  // Configure the client to use the local cluster.
  const provider = anchor.AnchorProvider.local(
    "https://devnet.helius-rpc.com/?api-key=0ff42e79-adbe-4960-b137-de8fea38bd19"
  );
  const connection = provider.connection;
  anchor.setProvider(provider);
  const program = anchor.workspace.IcyStakingSol as Program<IcyStakingSol>;

  const secretWallet = loadWallet("wallet.json");
  const creator = web3.Keypair.fromSeed(
    new Uint8Array(secretWallet.slice(0, 32))
  );

  const userWallet = loadWallet("user_wallet.json");
  const user = web3.Keypair.fromSeed(new Uint8Array(userWallet.slice(0, 32)));

  const stakeDetails = PublicKey.findProgramAddressSync(
    [
      Buffer.from("stake"),
      collectionAddress.toBuffer(),
      creator.publicKey.toBuffer(),
    ],
    program.programId
  )[0];

  const tokenAuthority = PublicKey.findProgramAddressSync(
    [Buffer.from("token-authority"), stakeDetails.toBuffer()],
    program.programId
  )[0];

  const nftAuthority = PublicKey.findProgramAddressSync(
    [Buffer.from("nft-authority"), stakeDetails.toBuffer()],
    program.programId
  )[0];

  const nftRecord = PublicKey.findProgramAddressSync(
    [
      Buffer.from("nft-record"),
      stakeDetails.toBuffer(),
      userNftMint.toBuffer(),
    ],
    program.programId
  )[0];

  const nftCustody = token.getAssociatedTokenAddressSync(
    userNftMint,
    nftAuthority,
    true
  );
  const stakeTokenVault = token.getAssociatedTokenAddressSync(
    rewardMint,
    tokenAuthority,
    true
  );

  it("init staking!", async () => {
    const minimumPeriod = new BN(0);
    const reward = new BN(100);

    const tx = await program.methods
      .initStaking(reward, minimumPeriod)
      .accounts({
        stakeDetails: stakeDetails,
        vaultTokenAuthority: tokenAuthority,
        collectionAddress: collectionAddress,
        nftAuthority: nftAuthority,
        stakeTokenVault: stakeTokenVault,
        creator: creator.publicKey,
        rewardMint: rewardMint,
      })
      .signers([creator])
      .rpc();

    console.log("TX: ", tx);

    let stakeAccount = await program.account.details.fetch(stakeDetails);
    console.log(stakeAccount);
  });

  it("add fund", async () => {
    const amount = new BN(100 * 10 ** rewardTokenDeciaml);

    const tx = await program.methods
      .addFun(amount)
      .accounts({
        stakeDetails: stakeDetails,
        vaultTokenAuthority: tokenAuthority,
        creatorTokenAccount: creatorRewardTokenAccount,
        stakeTokenVault: stakeTokenVault,
        creator: creator.publicKey,
        rewardMint: rewardMint,
      })
      .signers([creator])
      .rpc();

    console.log("TX: ", tx);
    let stakeTokenVaultAmount = await connection.getTokenAccountBalance(
      stakeTokenVault
    );
    console.log(stakeTokenVaultAmount.value.amount.toString());
  });

  it("withdraw fund", async () => {
    // const amount = new BN(100 * 10 ** rewardTokenDeciaml);

    const tx = await program.methods
      .withdrawFun()
      .accounts({
        stakeDetails: stakeDetails,
        vaultTokenAuthority: tokenAuthority,
        creatorTokenAccount: creatorRewardTokenAccount,
        stakeTokenVault: stakeTokenVault,
        creator: creator.publicKey,
        rewardMint: rewardMint,
      })
      .signers([creator])
      .rpc();

    console.log("TX: ", tx);
    let stakeTokenVaultAmount = await connection.getTokenAccountBalance(
      stakeTokenVault
    );
    console.log(stakeTokenVaultAmount.value.amount.toString());
  });

  it("stake nft", async () => {
    const tx = await program.methods
      .stake()
      .accounts({
        stakeDetails: stakeDetails,
        nftRecord: nftRecord,
        nftMint: userNftMint,
        nftToken: userNftTokenAccount,
        nftMetadata: userNftMetadata,
        nftAuthority: nftAuthority,
        nftEdition: userNftEdition,
        nftCustody: nftCustody,
        signer: user.publicKey,
      })
      .signers([user])
      .rpc();

    console.log("TX: ", tx);

    let stakeAccount = await program.account.details.fetch(stakeDetails);
    let nftRecordAccount = await program.account.nftRecord.fetch(nftRecord);

    console.log("Stake Details: ", stakeAccount);
    console.log("NFT Record: ", nftRecordAccount);
  });

  it("claims rewards without unstaking", async () => {
    let nftRecordAccount = await program.account.nftRecord.fetch(nftRecord);
    console.log("NFT Staked at: ", nftRecordAccount.stakedAt.toNumber());

    const userRewardTokenAccount = await getOrCreateAssociatedTokenAccount(
      connection,
      creator,
      rewardMint,
      user.publicKey,
      true
    );

    const tx = await program.methods
      .withdrawReward()
      .accounts({
        stakeDetails: stakeDetails,
        nftRecord: nftRecord,
        rewardMint: rewardMint,
        rewardReceiveAccount: userRewardTokenAccount.address,
        vaultTokenAuthority: tokenAuthority,
        stakeTokenVault: stakeTokenVault,
        staker: user.publicKey,
      })
      .signers([user])
      .rpc();

    console.log("TX: ", tx);

    nftRecordAccount = await program.account.nftRecord.fetch(nftRecord);
    console.log("NFT Staked at: ", nftRecordAccount.stakedAt.toNumber());
  });
  it("claims rewards and unstakes", async () => {
    const userRewardTokenAccount = await getOrCreateAssociatedTokenAccount(
      connection,
      creator,
      rewardMint,
      user.publicKey,
      true
    );
    const tx = await program.methods
      .unstake()
      .accounts({
        stakeDetails: stakeDetails,
        nftRecord: nftRecord,
        rewardMint: rewardMint,
        rewardReceiveAccount: userRewardTokenAccount.address,
        vaultTokenAuthority: tokenAuthority,
        nftAuthority: nftAuthority,
        nftCustody: nftCustody,
        nftMint: userNftMint,
        nftReceiveAccount: userNftTokenAccount,
        stakeTokenVault: stakeTokenVault,
        staker: user.publicKey,
      })
      .signers([user])
      .rpc();

    console.log("TX: ", tx);

    let stakeAccount = await program.account.details.fetch(stakeDetails);
    console.log("Stake Details: ", stakeAccount);
  });
});
