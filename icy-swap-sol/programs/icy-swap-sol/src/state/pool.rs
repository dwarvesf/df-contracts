use crate::constants::*;
use anchor_lang::prelude::*;

#[account]
#[derive(Default)]
pub struct Pool {
    /// Pubkey of admin
    pub admin: Pubkey,

    /// Mint of token A
    pub mint_a: Pubkey,

    /// Mint of token B
    pub mint_b: Pubkey,

    pub conversion_rate: f64,
}

impl Pool {
    pub const LEN: usize = 8 + PUBKEY_SIZE + PUBKEY_SIZE + PUBKEY_SIZE + F64_SIZE;
}
