use crate::constants::*;
use crate::state::*;
use anchor_lang::prelude::*;
use anchor_spl::{
    associated_token::AssociatedToken,
    token::{self, Mint, Token, TokenAccount, Transfer},
};

#[derive(Accounts)]
pub struct ClosePool<'info> {
    #[account(
        mut,
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
        mut,
        associated_token::mint = mint_a,
        associated_token::authority = admin,
    )]
    pub admin_account_a: Box<Account<'info, TokenAccount>>,

    #[account(
        mut,
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

pub fn handler(ctx: Context<ClosePool>) -> Result<()> {
    if ctx.accounts.pool_account_a.amount > 0 {
        // Transfer tokens a from pool to the admin
        token::transfer(
            CpiContext::new_with_signer(
                ctx.accounts.token_program.to_account_info(),
                Transfer {
                    from: ctx.accounts.pool_account_a.to_account_info(),
                    to: ctx.accounts.admin_account_a.to_account_info(),
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
            ctx.accounts.pool_account_a.amount,
        )?;
    }

    if ctx.accounts.pool_account_b.amount > 0 {
        // Transfer tokens b from pool to the admin
        token::transfer(
            CpiContext::new_with_signer(
                ctx.accounts.token_program.to_account_info(),
                Transfer {
                    from: ctx.accounts.pool_account_b.to_account_info(),
                    to: ctx.accounts.admin_account_b.to_account_info(),
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
            ctx.accounts.pool_account_b.amount,
        )?;
    }

    let pool = &mut ctx.accounts.pool;

    pool.close(ctx.accounts.admin.to_account_info())?;

    Ok(())
}
