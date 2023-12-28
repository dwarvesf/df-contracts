use crate::constants::*;
use crate::errors::*;
use crate::state::*;
use anchor_lang::prelude::*;
use anchor_spl::token::Mint;

#[derive(Accounts)]
pub struct UpdateConversionRate<'info> {
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

    pub mint_a: Box<Account<'info, Mint>>,

    pub mint_b: Box<Account<'info, Mint>>,

    /// The account paying for all rents
    #[account(mut)]
    pub admin: Signer<'info>,

    pub system_program: Program<'info, System>,
}

pub fn handler(ctx: Context<UpdateConversionRate>, new_conversion_rate: f64) -> Result<()> {
    require!(new_conversion_rate > 0f64, SwapError::InvalidConversionRate);
    let pool = &mut ctx.accounts.pool;
    pool.conversion_rate = new_conversion_rate;
    Ok(())
}
