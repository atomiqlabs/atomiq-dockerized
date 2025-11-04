
# atomiq node installation

## Pre-requisites
- A linux based machine (preferrably ubuntu 20.04 or 22.04)

## Preparations

### Installing docker
Install docker
~~~
sudo apt update
sudo apt install docker.io
~~~

### Setup firewall

Open ports 22, 80, 443 & 8443 in the firewall
~~~
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 8443
sudo ufw enable
~~~

## Installation

Unpack archive
~~~
sudo tar -xvzf atomiq-node*
~~~

Install docker-compose
~~~
sudo ./install-docker-compose.bash
~~~

Run setup script
~~~
sudo ./setup.bash
~~~

## Interact with the node

You can interact with the atomiq node through a CLI (command line interface)
~~~
./lp.cli
~~~

## Using CLI

### Checking node status

We need to wait for the bitcoin node to sync up to the network (download whole bitcoin blockchain, this takes few hours on testnet & up to a day on mainnet).

We can monitor the status of the sync progress with the status command
~~~
> status
Solana RPC status:
    Status: ready
Bitcoin RPC status:
    Status: verifying blockchain
    Verification progress: 6.8971%  <---- We can see the sync up/verification progress here
    Synced headers: 2812116
    Synced blocks: 549068
LND gRPC status:
    Wallet status: offline
Intermediary status:
    Status: wait_btc_rpc            <---- We can see intermediary node status here, once it's "ready" the node is synced and ready to roll
    Funds: 0.000000000
    Has enough funds (>0.1 SOL): no
~~~

### Depositing funds

While the node is syncing we can already deposit funds to the node, using 'getaddress' command we get the Solana & Bitcoin deposit addresses
~~~
> getaddress
Solana address: HpT88XAq69t8tjtfp4pTCmAvYYE38Qny46miLf9m1DnX
Bitcoin address: tb1qy5rl7esxn4nc9mysxwmvgw278w3lwrzwhy3f0f
~~~

After funds are deposited to the wallets we can track the balance with the 'getbalance' command (for BTC balances it only works after bitcoin node is synced)
~~~
> getbalance
Solana wallet balances (non-trading):
   USDC: 0.000000
   USDT: 0.000000
   WBTC: 0.00000000
   WSOL: 1.492930200
LP Vault balances (trading):
   USDC: 0.000000
   USDT: 0.000000
   WBTC: 0.00000000
   WSOL: 0.000000000
Bitcoin balances (trading):
   BTC: unknown (waiting for bitcoin node sync)
   BTC-LN: unknown (waiting for bitcoin node sync)
~~~

We also have to deposit Solana assets to the LP vault so they can be used for swaps (this doesn't have to be done with bitcoin assets) - repeat this for all the assets you want to be traded 'deposit <asset:USDC/USDT/WBTC/WSOL> <amount>'
~~~
> deposit WSOL 1
Transaction sent, signature: 4PxwU42k2xocYtspd8uAjNZahjU1YZSv6E4dXMziJRq9Ajd8ecjY8GQn8XXqGoJn6vxZ7F8W6qexMcTci3EuMda6 waiting for confirmation...
Deposit transaction confirmed!
~~~

Now we can check that the assets are really deposited and used for trading
~~~
> getbalance
Solana wallet balances (non-trading):
   USDC: 0.000000
   USDT: 0.000000
   WBTC: 0.00000000
   WSOL: 0.492930200
LP Vault balances (trading):
   USDC: 0.000000
   USDT: 0.000000
   WBTC: 0.00000000
   WSOL: 1.000000000
Bitcoin balances (trading):
   BTC: unknown (waiting for bitcoin node sync)
   BTC-LN: unknown (waiting for bitcoin node sync)
~~~

## Registering node

Once your node is synced up and ready (we can check that by using the 'status' command in the CLI)
~~~
./lp-cli
Connection to 127.0.0.1 40221 port [tcp/*] succeeded!
Welcome to atomiq intermediary (LP node) CLI!
Type 'help' to get a summary of existing commands!
> status
Solana RPC status:
    Status: ready
Bitcoin RPC status:
    Status: ready
    Verification progress: 100.0000%
    Synced headers: 2812140
    Synced blocks: 2812140
LND gRPC status:
    Wallet status: ready
Intermediary status:
    Status: ready               <---- We can see that our node is ready now!
    Funds: 0.292930200
    Has enough funds (>0.1 SOL): yes
~~~

We can now obtain the URL of the node with the 'geturl' command
~~~
> geturl
Node URL: https://81-17-102-136.nip.io:4000
~~~
