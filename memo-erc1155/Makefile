# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# Update dependencies
setup			:; make update-libs ; make install-deps
update-libs		:; git submodule update --init --recursive
install-deps	:; yarn install --frozen-lockfile

# Build & test & deploy
build         	:; forge build
xclean        	:; forge clean
lint          	:; yarn run lint
test          	:; forge test -vvv
test-gasreport 	:; forge test --gas-report
deploy-testnet :; forge script script/DeployScript.s.sol:DeployScript --rpc-url base_sepolia --private-key ${WALLET_PRIVATE_KEY} --broadcast --verify -vvvv
upgrade-testnet :; forge script script/UpgradeScript.s.sol:UpgradeScript --rpc-url base_sepolia --private-key ${WALLET_PRIVATE_KEY} --broadcast --verify -vvvv
deploy-mainnet :; forge script script/DeployScript.s.sol:DeployScript --rpc-url base --private-key ${WALLET_PRIVATE_KEY} --broadcast --verify -vvvv
upgrade-mainnet :; forge script script/UpgradeScript.s.sol:UpgradeScript --rpc-url base --private-key ${WALLET_PRIVATE_KEY} --broadcast --verify -vvvv
# test-fork     :; forge test --gas-report --fork-url ${ETH_NODE}
watch		  	:; forge test --watch src/ 