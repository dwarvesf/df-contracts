
## Installation

1. Install dependencies

```bash
nvm use
npm install
```

2. Update `.env` file

```bash
WALLET_KEY="<YOUR_PRIVATE_KEY>"
BASESCAN_API_KEY=<YOUR_BASE_SCAN_API_KEY>
ICY_CONTRACT=0xf289e3b222dd42b185b7e335fa3c5bd6d132441d
```

3. Deploy & verify factory contract

```bash
# deploy
npx hardhat ignition deploy ./ignition/modules/StakingPoolFactory.ts --network base-sepolia --deployment-id stakingpoolfactory

# verify
npx hardhat ignition verify stakingpoolfactory
```

## Deploy a staking pool

- Go to `https://sepolia.basescan.org/address/<deployed_contract_address>#writeContract`
- Connect wallet & execute `deploy` method to deploy a new `StakingPool`  with arguments:
  - `stakingToken` 
  - `rewardToken`
  - `rewardAmount` - Initial reward token amount transfered to pool
  - `rewardTotalAmount` - Maximum reward token amount for pool

***Verify staking pool contract***

1. From source code, open json file located at `ignition/deployments/build-info` and copy value of `input` field to a new json file `example.json`
2. Go to `https://sepolia.basescan.org/address/<deployed_contract_address>#readContract`, execute method `stakingPoolInfoByStakingToken` with input `<staking_token_address>_<reward_token_address>` to get pool address
3. Finally, open `https://base-sepolia.blockscout.com/address/<pool_contract_address>?tab=contract` and upload the `example.json` file to verify pool contract.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)