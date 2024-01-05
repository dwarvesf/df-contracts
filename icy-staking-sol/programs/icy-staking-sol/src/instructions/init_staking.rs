use anchor_lang::prelude::*;
use anchor_spl::{
    token::{Mint, Token, TokenAccount},
    associated_token::AssociatedToken
};
use crate::state::*;
use crate::errors::*;

#[derive(Accounts)]
pub struct InitStaking<'info> {
    #[account(
        init,
        payer = creator,
        space = Details::LEN,
        seeds = [
            b"stake",
            collection_address.key().as_ref(),
            creator.key().as_ref()
        ],
        bump
    )]
    pub stake_details: Account<'info, Details>,

    pub reward_mint: Account<'info, Mint>,

    #[account(
        init_if_needed,
        payer = creator,
        associated_token::mint = reward_mint,
        associated_token::authority = vault_token_authority,
    )]
    pub stake_token_vault: Account<'info, TokenAccount>,

    #[account(
        mint::decimals = 0,
    )]
    pub collection_address: Account<'info, Mint>,

    #[account(mut)]
    pub creator: Signer<'info>,

    /// CHECK: This account is not read or written
    #[account(
        seeds = [
            b"token-authority",
            stake_details.key().as_ref()
        ],
        bump
    )]
    pub vault_token_authority: AccountInfo<'info>,

    /// CHECK: This account is not read or written
    #[account(
        seeds = [
            b"nft-authority",
            stake_details.key().as_ref()
        ],
        bump
    )]
    pub nft_authority: AccountInfo<'info>,

    pub token_program: Program<'info, Token>,
    pub associated_token_program: Program<'info, AssociatedToken>,
    pub system_program: Program<'info, System>
}

pub fn handler(
    ctx: Context<InitStaking>,
    reward: u64,
    minimum_period: i64,
) -> Result<()> {
    require_gte!(minimum_period, 0, StakeError::NegativePeriodValue);

    let reward_mint = ctx.accounts.reward_mint.key();
    let collection = ctx.accounts.collection_address.key();
    let creator = ctx.accounts.creator.key();

    let stake_details = &mut ctx.accounts.stake_details;

    **stake_details = Details::init(
        creator,
        reward_mint,
        reward,
        collection,
        minimum_period,
    );


    Ok(())
}