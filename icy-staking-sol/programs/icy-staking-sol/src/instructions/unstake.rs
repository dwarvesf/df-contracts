use anchor_lang::prelude::*;
use anchor_spl::{
    token::{Mint, Token, TokenAccount, Transfer, CloseAccount, transfer, close_account},
    associated_token::AssociatedToken
};

use crate::{state::{Details, NftRecord}, utils::calc_reward, errors::StakeError};

#[derive(Accounts)]
pub struct Unstake<'info> {
    #[account(
        seeds = [
            b"stake",
            stake_details.collection.as_ref(),
            stake_details.creator.as_ref()
        ],
        bump,
        has_one = reward_mint
    )]
    pub stake_details: Account<'info, Details>,

    #[account(
        mut,
        seeds = [
        b"nft-record",
            stake_details.key().as_ref(),
            nft_record.nft_mint.as_ref(),
        ],
        bump,
        has_one = nft_mint,
        has_one = staker,
        close = staker
    )]
    pub nft_record: Account<'info, NftRecord>,

    pub reward_mint: Account<'info, Mint>,

    #[account(
        mut,
        associated_token::mint = reward_mint,
        associated_token::authority = vault_token_authority,
    )]
    pub stake_token_vault: Account<'info, TokenAccount>,

    #[account(
        init_if_needed,
        payer = staker,
        associated_token::mint = reward_mint,
        associated_token::authority = staker
    )]
    pub reward_receive_account: Box<Account<'info, TokenAccount>>,

    #[account(
        mint::decimals = 0,
        constraint = nft_mint.supply == 1 @ StakeError::TokenNotNFT,
    )]
    nft_mint: Box<Account<'info, Mint>>,

    #[account(
        init_if_needed,
        payer = staker,
        associated_token::mint = nft_mint,
        associated_token::authority = staker,
    )]
    nft_receive_account: Box<Account<'info, TokenAccount>>,

    #[account(
        mut,
        associated_token::mint = nft_mint,
        associated_token::authority = nft_authority,
        constraint = nft_custody.amount == 1 @ StakeError::TokenAccountEmpty,
    )]
    pub nft_custody: Box<Account<'info, TokenAccount>>,

    /// CHECK: This account is not read or written
    #[account(
        seeds = [
            b"token-authority",
            stake_details.key().as_ref(),
        ],
        bump
    )]
    pub vault_token_authority: AccountInfo<'info>,

    /// CHECK: This account is not read or written
    #[account(
        seeds = [
            b"nft-authority",
            stake_details.key().as_ref()
        ],
        bump
    )]
    pub nft_authority: AccountInfo<'info>,

    #[account(mut)]
    pub staker: Signer<'info>,

    pub token_program: Program<'info, Token>,
    pub associated_token_program: Program<'info, AssociatedToken>,
    pub system_program: Program<'info, System>
}

impl<'info> Unstake<'info> {
    pub fn transfer_token_ctx(&self) -> CpiContext<'_, '_, '_, 'info, Transfer<'info>> {
        let cpi_accounts = Transfer {
            from: self.stake_token_vault.to_account_info(),
            to: self.reward_receive_account.to_account_info(),
            authority: self.vault_token_authority.to_account_info()
        };
        let cpi_program = self.token_program.to_account_info();
        CpiContext::new(cpi_program, cpi_accounts)
    }

    pub fn transfer_nft_ctx(&self) -> CpiContext<'_, '_, '_, 'info, Transfer<'info>> {
        let cpi_accounts = Transfer {
            from: self.nft_custody.to_account_info(),
            to: self.nft_receive_account.to_account_info(),
            authority: self.nft_authority.to_account_info()
        };
        let cpi_program = self.token_program.to_account_info();
        CpiContext::new(cpi_program, cpi_accounts)
    }

    pub fn close_account_ctx(&self)-> CpiContext<'_, '_, '_, 'info, CloseAccount<'info>> {
        let cpi_accounts = CloseAccount {
            account: self.nft_custody.to_account_info(),
            destination: self.staker.to_account_info(),
            authority: self.nft_authority.to_account_info()
        };
        let cpi_program = self.token_program.to_account_info();
        CpiContext::new(cpi_program, cpi_accounts)
    }
}

pub fn handler(ctx: Context<Unstake>) -> Result<()> {
    let stake_details = &ctx.accounts.stake_details;

    let staked_at = ctx.accounts.nft_record.staked_at;
    let minimum_stake_period = stake_details.minimum_period;
    let reward_emission = stake_details.reward;
    let stake_details_key = stake_details.key();
    let reward_pool_amount = ctx.accounts.stake_token_vault.amount;
    let mut amount_transfer: u64 = 0;

    let (reward_tokens, _current_time, is_eligible_for_reward) = calc_reward(
        staked_at,
        minimum_stake_period,
        reward_emission,
    ).unwrap();

    if reward_tokens > reward_pool_amount {
        amount_transfer = reward_pool_amount;
    } else { amount_transfer = reward_tokens }

    let token_auth_seed = &[&b"token-authority"[..], &stake_details_key.as_ref(), &[ctx.bumps.vault_token_authority]];
    let nft_auth_seed = &[&b"nft-authority"[..], &stake_details_key.as_ref(), &[ctx.bumps.nft_authority]];

    if is_eligible_for_reward {
        // Mint Reward Tokens
        if amount_transfer > 0 {
            transfer(
                ctx.accounts.transfer_token_ctx().with_signer(&[&token_auth_seed[..]]),
                amount_transfer
            )?;
        }
    }

    // Transfer NFT
    transfer(
        ctx.accounts.transfer_nft_ctx().with_signer(&[&nft_auth_seed[..]]),
        1
    )?;

    // Close NFT Custody Account
    close_account(ctx.accounts.close_account_ctx().with_signer(&[&nft_auth_seed[..]]))?;

    Ok(())
}