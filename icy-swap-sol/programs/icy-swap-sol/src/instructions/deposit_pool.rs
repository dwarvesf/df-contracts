use crate::constants::*;
use crate::errors::*;
use crate::state::*;
use anchor_lang::prelude::*;
use anchor_spl::{
    associated_token::AssociatedToken,
    token::{self, Mint, Token, TokenAccount, Transfer},
};

#[derive(Accounts)]
pub struct DepositPool<'info> {
    #[account(
        seeds = [
            pool.admin.as_ref(),
            mint_a.key().as_ref(),
            mint_b.key().as_ref(),
            POOL_SEED.as_ref(),
        ],
        bump,
        has_one = mint_a,
        has_one = mint_b,
        constraint = pool.admin == admin.key()
    )]
    pub pool: Account<'info, Pool>,

    /// CHECK: Read only authority
    #[account(
        seeds = [
            pool.admin.as_ref(),
            mint_a.key().as_ref(),
            mint_b.key().as_ref(),
            AUTHORITY_SEED.as_ref(),
        ],
        bump,
        constraint = pool.admin == admin.key()
    )]
    pub pool_authority: AccountInfo<'info>,

    pub mint_a: Box<Account<'info, Mint>>,

    pub mint_b: Box<Account<'info, Mint>>,

    #[account(
        mut,
        associated_token::mint = mint_a,
        associated_token::authority = pool_authority,
    )]
    pub pool_account_a: Box<Account<'info, TokenAccount>>,

    #[account(
        mut,
        associated_token::mint = mint_b,
        associated_token::authority = pool_authority,
    )]
    pub pool_account_b: Box<Account<'info, TokenAccount>>,

    #[account(
        init_if_needed,
        payer = admin,
        associated_token::mint = mint_a,
        associated_token::authority = admin,
    )]
    pub admin_account_a: Box<Account<'info, TokenAccount>>,

    #[account(
        init_if_needed,
        payer = admin,
        associated_token::mint = mint_b,
        associated_token::authority = admin,
    )]
    pub admin_account_b: Box<Account<'info, TokenAccount>>,

    /// The account paying for all rents
    #[account(mut)]
    pub admin: Signer<'info>,

    /// Solana ecosystem accounts
    pub token_program: Program<'info, Token>,
    pub associated_token_program: Program<'info, AssociatedToken>,
    pub system_program: Program<'info, System>,
}

pub fn handler(ctx: Context<DepositPool>, amount_a: u64, amount_b: u64) -> Result<()> {
    if amount_a > 0 {
        require!(
            amount_a <= ctx.accounts.admin_account_a.amount,
            SwapError::InsufficientAmount
        );

        // Transfer tokens to the pool
        token::transfer(
            CpiContext::new(
                ctx.accounts.token_program.to_account_info(),
                Transfer {
                    from: ctx.accounts.admin_account_a.to_account_info(),
                    to: ctx.accounts.pool_account_a.to_account_info(),
                    authority: ctx.accounts.admin.to_account_info(),
                },
            ),
            amount_a,
        )?;
    }

    if amount_b > 0 {
        require!(
            amount_b <= ctx.accounts.admin_account_b.amount,
            SwapError::InsufficientAmount
        );

        // Transfer tokens to the pool
        token::transfer(
            CpiContext::new(
                ctx.accounts.token_program.to_account_info(),
                Transfer {
                    from: ctx.accounts.admin_account_b.to_account_info(),
                    to: ctx.accounts.pool_account_b.to_account_info(),
                    authority: ctx.accounts.admin.to_account_info(),
                },
            ),
            amount_b,
        )?;
    }

    Ok(())
}
