use anchor_lang::prelude::*;

use crate::{state::Details, errors::StakeError};

#[derive(Accounts)]
pub struct ChangeMinimumPeriod<'info> {
    #[account(
        mut,
        seeds = [
        b"stake",
        stake_details.collection.as_ref(),
        stake_details.creator.as_ref()
        ],
        bump,
        has_one = creator
    )]
    pub stake_details: Account<'info, Details>,

    #[account(mut)]
    pub creator: Signer<'info>,

    pub system_program: Program<'info, System>
}

pub fn handler(ctx: Context<ChangeMinimumPeriod>, new_minimum_period: i64) -> Result<()> {
    require_gte!(new_minimum_period, 0, StakeError::NegativePeriodValue);

    let stake_details = &mut ctx.accounts.stake_details;

    stake_details.minimum_period = new_minimum_period;

    Ok(())
}