use anchor_lang::prelude::*;
use anchor_spl::token::{transfer, Transfer, Token, TokenAccount, Mint};

use crate::{state::Details};
use crate::errors::StakeError;

#[derive(Accounts)]
pub struct AddFund<'info> {
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

impl<'info> AddFund<'info> {
    pub fn transfer_token_ctx(&self) -> CpiContext<'_, '_, '_, 'info, Transfer<'info>> {
        let cpi_accounts = Transfer {
            from: self.creator_token_account.to_account_info(),
            to: self.stake_token_vault.to_account_info(),
            authority: self.creator.to_account_info()
        };

        let cpi_program = self.token_program.to_account_info();

        CpiContext::new(cpi_program, cpi_accounts)
    }
}

pub fn handler(ctx: Context<AddFund>, amount: u64) -> Result<()> {
    require_gt!(amount, 0, StakeError::InvalidAmount);

    transfer(ctx.accounts.transfer_token_ctx(), amount)?;

    Ok(())
}