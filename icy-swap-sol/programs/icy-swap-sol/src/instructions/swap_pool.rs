use crate::constants::*;
use crate::errors::*;
use crate::state::*;
use anchor_lang::prelude::*;
use anchor_spl::{
    associated_token::AssociatedToken,
    token::{self, Mint, Token, TokenAccount, Transfer},
};

#[derive(Accounts)]
pub struct SwapPool<'info> {
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
        bump
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
        payer = user,
        associated_token::mint = mint_a,
        associated_token::authority = user,
    )]
    pub user_account_a: Box<Account<'info, TokenAccount>>,

    #[account(
        init_if_needed,
        payer = user,
        associated_token::mint = mint_b,
        associated_token::authority = user,
    )]
    pub user_account_b: Box<Account<'info, TokenAccount>>,

    /// The account paying for all rents
    #[account(mut)]
    pub user: Signer<'info>,

    /// Solana ecosystem accounts
    pub token_program: Program<'info, Token>,
    pub associated_token_program: Program<'info, AssociatedToken>,
    pub system_program: Program<'info, System>,
}

pub fn handler(ctx: Context<SwapPool>, amount_a: u64) -> Result<()> {
    require!(amount_a > 0, SwapError::InvalidAmount);

    require!(
        amount_a <= ctx.accounts.user_account_a.amount,
        SwapError::InsufficientAmount
    );

    let decimal_a = *&ctx.accounts.mint_a.decimals;
    let decimal_b = *&ctx.accounts.mint_b.decimals;
    let conversion_rate = ctx.accounts.pool.conversion_rate;

    let amount_b = (((amount_a / u64::pow(10, decimal_a as u32)) as f64 * conversion_rate)
        * u64::pow(10, decimal_b as u32) as f64) as u64;

    require!(
        amount_b <= ctx.accounts.pool_account_b.amount,
        SwapError::InsufficientAmount
    );

    // Transfer tokens a from user to the pool
    token::transfer(
        CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            Transfer {
                from: ctx.accounts.user_account_a.to_account_info(),
                to: ctx.accounts.pool_account_a.to_account_info(),
                authority: ctx.accounts.user.to_account_info(),
            },
        ),
        amount_a,
    )?;

    // Transfer tokens b from pool to the user
    token::transfer(
        CpiContext::new_with_signer(
            ctx.accounts.token_program.to_account_info(),
            Transfer {
                from: ctx.accounts.pool_account_b.to_account_info(),
                to: ctx.accounts.user_account_b.to_account_info(),
                authority: ctx.accounts.pool_authority.to_account_info(),
            },
            &[&[
                &ctx.accounts.pool.admin.to_bytes(),
                &ctx.accounts.mint_a.key().to_bytes(),
                &ctx.accounts.mint_b.key().to_bytes(),
                AUTHORITY_SEED.as_bytes(),
                &[ctx.bumps.pool_authority],
            ]],
        ),
        amount_b,
    )?;

    Ok(())
}
