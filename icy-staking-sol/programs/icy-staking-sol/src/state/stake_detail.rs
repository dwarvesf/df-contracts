use anchor_lang::prelude::*;

#[account]
pub struct Details {
    /// The creator of the stake record (32)
    pub creator: Pubkey,
    /// The mint of the token to be given as a reward (32)
    pub reward_mint: Pubkey,
    /// The rate of reward emission per second (8)
    pub reward: u64,
    /// The verified collection address of the NFT (32)
    pub collection: Pubkey,
    /// The minimum stake period to be eligible for reward - in seconds (8)
    pub minimum_period: i64,
}

impl Details {
    pub const LEN: usize = 8 + 32 + 32 + 8 + 32 + 8;

    pub fn init(
        creator: Pubkey,
        reward_mint: Pubkey,
        reward: u64,
        collection: Pubkey,
        minimum_period: i64,
    ) -> Self {
        Self {
            creator,
            reward_mint,
            reward,
            collection,
            minimum_period,
        }
    }
}