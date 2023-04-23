#Foundry Contract Guide

Foundry GitHub - [https://github.com/foundry-rs](https://github.com/foundry-rs)  
Foundry Book - [https://book.getfoundry.sh/](https://book.getfoundry.sh/)  
Installing Foundry - [https://github.com/foundry-rs/foundry#installation](https://github.com/foundry-rs/foundry#installation)

Foundry is made up of three components:

[Forge](https://github.com/foundry-rs/foundry/tree/master/forge): Ethereum testing framework (like Truffle, Hardhat and DappTools).  
[Cast](https://github.com/foundry-rs/foundry/tree/master/cast): CLI for interacting with EVM smart contracts, sending transactions and getting chain data.  
[Anvil](https://github.com/foundry-rs/foundry/tree/master/anvil): local Ethereum node, similar to Ganache or Hardhat Network.

Forge includes both a CLI as well as a [standard library](https://github.com/foundry-rs/forge-std).

For an introduction to Foundry, check out these resources:

- [Foundry vs Hardhat: Differences in performance and developer experience](https://chainstack.com/foundry-hardhat-differences-performance/)
- [Smart Contract Development with Foundry (Video)](https://www.youtube.com/watch?v=uelA2U9TbgM)
- [Building and testing smart contracts with Foundry (tutorial)](https://nader.mirror.xyz/6Mn3HjrqKLhHzu2balLPv4SqE5a-oEESl4ycpRkWFsc)

For support, check out the Telegram channel [here](https://t.me/foundry_support)

## Initializing a new project

Initialize a new project from an empty folder:

```sh
forge init
```

Or define a new folder in which to create your project:

```sh
forge init my-app
```

This creates a new project with 4 folders:

**src** - An example smart contract and where your smart contracts will live.

**script** - An example deployment script

**test** - An example test

**lib** - This is similar to **node_modules**

### Remappings

Forge can remap dependencies to make them easier to import. Forge will automatically try to deduce some remappings for you:

```sh
forge remappings
forge install rari-capital/solmate
forge update lib/solmate
forge remove solmate

npm i @openzeppelin/contracts
```

create file named remappings.txt and write:

```sh
@openzeppelin/=node_modules/@openzeppelin
```

If you're using VS Code, you can configure your remappings by installing [vscode-solidity](https://github.com/juanfranblanco/vscode-solidity).

Learn more about how remappings work [here](https://book.getfoundry.sh/projects/dependencies.html?highlight=remappings#remapping-dependencies)

## Testing

You can execute tests by running the `forge test` script.

```sh
forge test
forge test --match-path test/xyz.sol
```

Any contract with a function that starts with `test` is considered to be a test.
Usually, tests will be placed in `src/test` by convention and end with `.t.sol`.

Foundry uses `Dappsys Test` (DSTest) to provide basic logging and assertion functionality. It's included in the Forge Standard Library.

It includes assertions such as:

```solidity
assertTrue
assertEq
assertEqDecimal
assertEq32
assertEq0
assertGt
assertGtDecimal
assertGe
assertGeDecimal
assertLt
assertLtDecimal
assertLe
assertLeDecimal
```

You can view all of the assertion functions available [here](https://book.getfoundry.sh/reference/)

The default behavior for `forge test` is to only display a summary of passing and failing tests. You can control this behavior by increasing the verbosity (using the `-v` flag). Each level of verbosity adds more information:

**Level 2 (`-vv`)**: Logs emitted during tests are also displayed. That includes assertion errors from tests, showing information such as expected vs actual.  
**Level 3 (`-vvv`)**: Stack traces for failing tests are also displayed.  
**Level 4 (`-vvvv`)**: Stack traces for all tests are displayed, and setup traces for failing tests are displayed.  
**Level 5 (`-vvvvv`)**: Stack traces and setup traces are always displayed.

For our logs to show up, we need to run `test` with at least the `-vv` flag:

```sh
forge test -vv
forge test --match-path test/Console.t.sol -vv
```

### Gas

You can easily print a pretty looking gas report of your tested functions:

```sh
forge test --gas-report
```

### ABIs

ABIs will be located in the `out` directory after running either a build with `forge build` or a deployment with a script.

### Test Options

You can get a full list of testing options by running the `--help` command:

```sh
forge test --help
```

## Scripts & deploying

Foundry provides Solidity Scripting.

[Scripting](https://book.getfoundry.sh/tutorials/solidity-scripting.html) gives you a lot of control over how you can deploy contracts using Solidity scripts, and I believe is meant to replace [`forge create`](https://book.getfoundry.sh/reference/forge/forge-create.html) which was previously how you could deploy contracts.

From [Foundry Book](https://book.getfoundry.sh/tutorials/solidity-scripting.html):

> Solidity scripts are like the scripts you write when working with tools like Hardhat; what makes Solidity scripting different is that they are written in Solidity instead of JavaScript, and they are run on the fast Foundry EVM backend, which provides dry-run capabilities.

Let's look at how to deploy our contract using Solidity Scripting.

Scripts are executed by calling the function named `run`, our entrypoint.

Using the address that calls the test contract or the address provided as the sender, `startBroadcast` and `startBroadcast(address)` will have all subsequent calls (at this call depth only) create transactions that can later be signed and sent onchain.

`stopBroadcast` stops collecting transactions for later on-chain broadcasting.

You can also use `broadcast`, using the address that calls the test contract, has the next call (at this call depth only) create a transaction that can later be signed and sent onchain

Or `broadcast(address)` using the address provided as the sender, have only the next call (at this call depth) create a transaction that can later be signed and sent onchain.

## Deploying locally

Next start Anvil, the local testnet:

```sh
anvil
```

Once started, Anvil will give you a local RPC endpoint as well as a handful of Private Keys and Accounts that you can use.

We can now use the local RPC along with one of the private keys to deploy locally:

```sh
forge script script/Contract.s.sol:ContractScript --fork-url http://localhost:8545 \
--private-key $PRIVATE_KEY --broadcast
```

### Using cast to perform Ethereum RPC calls

Once the contract has been deployed locally, Anvil will log out the contract address.

Next, set the contract address as an environment variable:

```sh
export CONTRACT_ADDRESS=<contract-address>
```

We can then test sending transactions to it with `cast send`.

```sh
cast send $CONTRACT_ADDRESS "incrementCounter()" \
--private-key $PRIVATE_KEY
```

We can then perform read operations with `cast call`:

```sh
cast call $CONTRACT_ADDRESS "getCount()(int)"
```

## Deploying to a network

Now that we've deployed and tested locally, we can deploy to a network.

To do so, run the following script:

```sh
forge script script/Contract.s.sol:ContractScript --rpc-url $RPC_URL \
 --private-key $PRIVATE_KEY --broadcast
```

Once the contract has been deployed to the network, we can use cast send to test sending transactions to it:

```sh
cast send $CONTRACT_ADDRESS "incrementCounter()" --rpc-url $RPC_URL \
--private-key $PRIVATE_KEY
```

We can then perform read operations with cast call:

```sh
cast call $CONTRACT_ADDRESS "getCount()(int)" --rpc-url $RPC_URL
```

### Cast Options

You can get a full list of commands by running the `--help` command:

```sh
cast --help
```
