use anchor_lang::prelude::*;

#[error_code]
pub enum StakeError {
    #[msg("the minimum staking period in secs can't be negative")]
    NegativePeriodValue,

    #[msg("failed to convert the time to u64")]
    FailedTimeConversion,

    #[msg("unable to add the given values")]
    ProgramAddError,

    #[msg("unable to subtract the given values")]
    ProgramSubError,

    #[msg("unable to multiply the given values")]
    ProgramMulError,

    #[msg("the given mint account doesn't belong to NFT")]
    TokenNotNFT,

    #[msg("the given token account has no token")]
    TokenAccountEmpty,

    #[msg("the collection field in the metadata is not verified")]
    CollectionNotVerified,

    #[msg("the collection doesn't match the staking details")]
    InvalidCollection,

    #[msg("the minimum stake period for the rewards not completed yet")]
    IneligibleForReward,

    #[msg("the reward is invalid")]
    InvalidReward,

    #[msg("the amount is invalid")]
    InvalidAmount,

    #[msg("the fund is insufficient")]
    InsufficientFund,
}
