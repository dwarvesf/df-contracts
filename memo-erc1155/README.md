# Dwarves Memo - ERC1155
## Overview
We're developing an upgradable ERC1155 smart contract that integrates with Arweave for storing NFT metadata. This contract will allow the owner to create new NFT types mapped to Arweave transaction IDs, while enabling anyone to mint tokens of these established types.

## Methods

### createTokenType
Only callable by contract owner to maps a new NFT ID to an Arweave transaction ID

### updateTokenType
Only callable by contract owner to update the Arweave transaction ID for an existing NFT ID

### mintNFT
Allows any user to mint tokens of an existing type

### readNFT
Returns the Arweave gateway URL for the token's metadata

## Installation
This codebase requires [Foundry](https://github.com/gakonst/foundry) installed to run. You can find instructions here [Foundry installation](https://github.com/gakonst/foundry#installation).

## Usage
### Install dependencies
```bash
make
```

### Compile
```bash
make build
```

### Test
```bash
make test
```

### Deploy
1. For testnet
```bash
make deploy-testnet
```
2. For mainnet
```bash
make deploy-mainnet
```
### Upgrade
```bash
make upgrade-testnet
```
2. For mainnet
```bash
make upgrade-mainnet
```


