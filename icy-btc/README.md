## Icy Btc Contract

This contract will be used as a component in icy-btc swap feature. Main responsibilities

- Icy Burner
- Emit log after burn
- Set signer

## How to deploy

1. cp .env.sample .env
2. Update .env file
3. run deploy script

```shell
forge script script/DeployIcyBtcSwap.s.sol:DeployIcyBtcSwap --rpc-url <your_rpc_url> --broadcast --verify
```

# Foundry related docs

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
