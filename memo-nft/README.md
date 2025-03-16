# This repo is an implementation of the Memo NFT contract.

## Contract

- [DwarvesMemo.sol](./src/DwarvesMemo.sol)

## Overview
We're developing an upgradable ERC1155 smart contract that integrates with Arweave for storing NFT metadata. This contract will allow the owner to create new NFT types mapped to Arweave transaction IDs, while enabling anyone to mint tokens of these established types.

### Features
- Upgradable
- ERC1155
- Integrates with Arweave
- ...

### Smart Contract Functionalities
1. `createTokenType (onlyOwner)` -> Maps a new NFT ID to an Arweave transaction ID
2. `updateTokenType (onlyOwner)` -> Updates the Arweave transaction ID for an existing NFT ID
3. `mintNFT (public)` -> Mints a new NFT token
4. `readNFT (public)` -> Returns the Arweave gateway URL for the token's metadata
5. `getUniqueMinterCount (public)` -> Returns the total number of unique addresses that have minted at least one NFT

## Usage
### Prerequisites
- Install `Bun` CLI (https://bun.sh/docs/installation)
- Install `Foundry` (https://getfoundry.sh/)
- Install dependencies: `bun install`
- Update `.env` file with your own values (see `.env.example`)

### Available commands
1. Build commands
- `bun run build` -> Build the contract (always run this before deploying)

2. Deploy commands
- `bun run deploy:testnet` -> Deploy to Base Sepolia
- `bun run deploy:mainnet` -> Deploy to Base Mainnet

3. Upgrade commands
- `bun run upgrade:testnet` -> Upgrade on Base Sepolia
- `bun run upgrade:mainnet` -> Upgrade on Base Mainnet

4. Other commands
- `bun run test` -> Run tests
- `bun run lint` -> Run lint
- `bun run format` -> Format code

## Latest Deployments
1. Testnet
- [Implementation](https://sepolia.basescan.org/address/0x6B6F2fb06D8487337201e27eE54EB30f29A3216e)
- [Proxy](https://sepolia.basescan.org/address/0x2934541b90a631e9C5ea70a4177475a2C5735916)

2. Mainnet
- ...

## Resources
- [Arweave Integration](https://academy.developerdao.com/tracks/arweave-101/2)
- [Foundry Book](https://book.getfoundry.sh/)
- [Foundry Template](https://github.com/PaulRBerg/foundry-template)