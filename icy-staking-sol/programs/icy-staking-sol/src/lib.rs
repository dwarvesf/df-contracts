pub mod errors;
pub mod instructions;
pub mod state;
mod utils;

use anchor_lang::prelude::*;
use instructions::*;

declare_id!("62ijJV2fK3TsyGhC4y1cbiJnb2UyqTCsuKtEgPX2Sj7B");

#[program]
pub mod icy_staking_sol {
    use super::*;
    pub fn init_staking(ctx: Context<InitStaking>, reward: u64, minimum_period: i64) -> Result<()> {
        init_staking::handler(ctx, reward, minimum_period)
    }
    pub fn stake(ctx: Context<Stake>) -> Result<()> {
        stake::handler(ctx)
    }
    pub fn unstake(ctx: Context<Unstake>) -> Result<()> {
        unstake::handler(ctx)
    }
    pub fn withdraw_reward(ctx: Context<WithdrawReward>) -> Result<()> {
        withdraw_reward::handler(ctx)
    }
    pub fn add_fun(ctx: Context<AddFund>, amount: u64) -> Result<()> {
        add_fund::handler(ctx, amount)
    }

    pub fn withdraw_fun(ctx: Context<WithdrawFund>) -> Result<()> {
        withdraw_fun::handler(ctx)
    }

    pub fn change_reward(ctx: Context<ChangeReward>, new_reward: u64) -> Result<()> {
        change_reward::handler(ctx, new_reward)
    }

    pub fn change_minimum_period(ctx: Context<ChangeMinimumPeriod>, new_minimum_period: i64) -> Result<()> {
        change_minimum_period::handler(ctx, new_minimum_period)
    }
}
