use anchor_lang::prelude::*;
use anchor_spl::token::{transfer, Transfer, Token, TokenAccount, Mint};

use crate::{state::Details};
use crate::errors::StakeError;

#[derive(Accounts)]
pub struct WithdrawFund<'info> {
    #[account(
        mut,
        seeds = [
            b"stake",
            stake_details.collection.as_ref(),
            stake_details.creator.as_ref()
        ],
        bump,
        has_one = creator,
        has_one = reward_mint
    )]
    pub stake_details: Account<'info, Details>,

    pub reward_mint: Account<'info, Mint>,

    #[account(
        mut,
        associated_token::mint = reward_mint,
        associated_token::authority = creator
    )]
    pub creator_token_account: Account<'info, TokenAccount>,

    #[account(
        mut,
        associated_token::mint = reward_mint,
        associated_token::authority = vault_token_authority,
    )]
    pub stake_token_vault: Account<'info, TokenAccount>,

    /// CHECK: This account is not read or written
    #[account(
        seeds = [
            b"token-authority",
            stake_details.key().as_ref()
        ],
        bump
    )]
    pub vault_token_authority: AccountInfo<'info>,

    pub creator: Signer<'info>,
    pub token_program: Program<'info, Token>
}

impl<'info> WithdrawFund<'info> {
    pub fn transfer_token_ctx(&self) -> CpiContext<'_, '_, '_, 'info, Transfer<'info>> {
        let cpi_accounts = Transfer {
            from: self.stake_token_vault.to_account_info(),
            to: self.creator_token_account.to_account_info(),
            authority: self.vault_token_authority.to_account_info()
        };
        let cpi_program = self.token_program.to_account_info();
        CpiContext::new(cpi_program, cpi_accounts)
    }
}

pub fn handler(ctx: Context<WithdrawFund>) -> Result<()> {
    let amount = ctx.accounts.stake_token_vault.amount;

    require_gte!(amount, 0, StakeError::InsufficientFund);

    let stake_details = &ctx.accounts.stake_details;
    let stake_details_key = stake_details.key();

    let authority_seed = &[&b"token-authority"[..], &stake_details_key.as_ref(), &[ctx.bumps.vault_token_authority]];

    transfer(
        ctx.accounts.transfer_token_ctx().with_signer(&[&authority_seed[..]]),
        amount
    )?;

    Ok(())
}