use anchor_lang::prelude::*;

#[account]
pub struct NftRecord {
    /// The owner/staker of the NFT (32)
    pub staker: Pubkey,
    /// The mint of the staked NFT (32)
    pub nft_mint: Pubkey,
    /// The staking timestamp (8)
    pub staked_at: i64,
}

impl NftRecord {
    pub const LEN: usize = 8 + 32 + 32 + 8;

    pub fn init(staker: Pubkey, nft_mint: Pubkey) -> Self {
        let clock = Clock::get().unwrap();
        let staked_at = clock.unix_timestamp;

        Self {staker, nft_mint, staked_at}
    }
}