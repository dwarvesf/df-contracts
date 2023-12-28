pub mod constants;
pub mod errors;
pub mod instructions;
pub mod state;

use anchor_lang::prelude::*;
use instructions::*;

declare_id!("4g6779PDmQjoCKUwhbjwgBQ3FkfgTgEPsXwwUcGkgq4A");

#[program]
pub mod icy_swap_sol {
    use super::*;

    pub fn create_pool(ctx: Context<CreatePool>, conversion_rate: f64) -> Result<()> {
        create_pool::handler(ctx, conversion_rate)
    }

    pub fn deposit_pool(ctx: Context<DepositPool>, amount_a: u64, amount_b: u64) -> Result<()> {
        deposit_pool::handler(ctx, amount_a, amount_b)
    }

    pub fn update_conversion_rate(
        ctx: Context<UpdateConversionRate>,
        new_conversion_rate: f64,
    ) -> Result<()> {
        update_conversion_rate::handler(ctx, new_conversion_rate)
    }

    pub fn withdraw_pool(ctx: Context<WithdrawPool>, amount_a: u64, amount_b: u64) -> Result<()> {
        withdraw_pool::handler(ctx, amount_a, amount_b)
    }

    pub fn swap_pool(ctx: Context<SwapPool>, amount_a: u64) -> Result<()> {
        swap_pool::handler(ctx, amount_a)
    }

    pub fn close_pool(ctx: Context<ClosePool>) -> Result<()> {
        close_pool::handler(ctx)
    }
}
