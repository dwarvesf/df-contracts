use anchor_lang::prelude::*;

#[error_code]
pub enum SwapError {
    #[msg("Invalid fee value")]
    InvalidFee,

    #[msg("Invalid mint for the pool")]
    InvalidMint,

    #[msg("Insufficient amount")]
    InsufficientAmount,

    #[msg("Invalid conversion rate")]
    InvalidConversionRate,

    #[msg("Invalid amount")]
    InvalidAmount,
}
