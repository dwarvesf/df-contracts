# ICY swap on solana

## Install, Build, Deploy and Test

### Install

1. install rust:
```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

2. install solana
```
$ sh -c "$(curl -sSfL https://release.solana.com/v1.17.13/install)"
```

3. install anchor
```
$ cargo install --git https://github.com/coral-xyz/anchor avm --locked --force

$ avm install latest

$ avm use latest
```

4. install dependencies
```
$ yarn
```

### Build and Deploy
Get the program ID:
```
$ anchor keys list
```

Build the program:

```
$ anchor build
```

Setup solana config 
```
- devnet
$ solana config set --url https://api.devnet.solana.com

```

Let's deploy the program.
```
$ anchor deploy
```

### Test
1. local 
- Skip the deploy step
```
$ anchor test
```

- devnet
```
$ anchor test --skip-deploy 
```


