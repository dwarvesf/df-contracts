use anchor_lang::prelude::*;

use crate::{state::Details, errors::StakeError};

#[derive(Accounts)]
pub struct ChangeReward<'info> {
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

pub fn handler(ctx: Context<ChangeReward>, new_reward: u64) -> Result<()> {
    require_gt!(new_reward, 0, StakeError::InvalidReward);

    let stake_details = &mut ctx.accounts.stake_details;

    stake_details.reward = new_reward;

    Ok(())
}