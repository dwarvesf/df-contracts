use anchor_lang::prelude::*;
#[constant]
pub const PUBKEY_SIZE: usize = std::mem::size_of::<Pubkey>();
#[constant]
pub const BOOL_SIZE: usize = std::mem::size_of::<bool>();
#[constant]
pub const I64_SIZE: usize = std::mem::size_of::<i64>();
#[constant]
pub const U64_SIZE: usize = std::mem::size_of::<u64>();
#[constant]
pub const F64_SIZE: usize = std::mem::size_of::<f64>();
#[constant]
pub const POOL_SEED: &str = "pool";
#[constant]
pub const AUTHORITY_SEED: &str = "authority";
