#!/bin/bash

echo "Unpacking docker images..."
rm -r images
tar -xvzf images.tar.gz

echo "Loading docker images..."
docker load --input images/bitcoind.tar
docker load --input images/lnd.tar
docker load --input images/btcrelay.tar
docker load --input images/intermediary.tar

# Ask which environment to setup, store this in a variable
read -p "Which environment to use (mainnet/testnet/testnet4)? " environment

if [ "$environment" != "mainnet" ] && [ "$environment" != "testnet" ] && [ "$environment" != "testnet4" ]; then
	echo "Invalid environment, valid are: mainnet, testnet, testnet4"
	exit 1
fi

# Ask for existing seed or create a new one
read -p "Do you wish to recover a wallet from the seed phrase or create a new one (new/recover)? " wallet

if [ "$wallet" != "new" ] && [ "$wallet" != "recover" ]; then
	echo "Invalid response, valid are: new, recover"
	exit 1
fi

if [ "$environment" == "mainnet" ]; then
	mkdir share
	mkdir share/wallet
	mnemonicFile="share/wallet/mnemonic.txt"
	birthdayFile="share/wallet/mnemonic-birthday.txt"
elif [ "$environment" == "testnet" ]; then
	mkdir share-testnet
	mkdir share-testnet/wallet
	mnemonicFile="share-testnet/wallet/mnemonic.txt"
	birthdayFile="share-testnet/wallet/mnemonic-birthday.txt"
else
	mkdir share-testnet4
	mkdir share-testnet4/wallet
	mnemonicFile="share-testnet4/wallet/mnemonic.txt"
	birthdayFile="share-testnet4/wallet/mnemonic-birthday.txt"
fi

if [ -f "$mnemonicFile" ]; then
	read -p "Mnemonic already found, are you sure you want to override it? (yes/no) " overrideMnemonic
	
	if [ "$overrideMnemonic" != "yes" ]; then
		echo "Not overriding existing mnemonic, exiting..."
		exit 1
	fi

	rm "${mnemonicFile}"
	rm "${mnemonicFile}.lnd"
fi

if [ "$wallet" == "new" ]; then
	# Call gen-mnemonic.bash for creating a new one
	bash gen-mnemonic.bash "${mnemonicFile}" "${birthdayFile}"
else
	# Call recover-mnemonic.bash for existing seed
	bash recover-mnemonic.bash "${mnemonicFile}" "${birthdayFile}"
fi

if [ "$environment" == "mainnet" ]; then
	passwordFile="share/wallet/password.txt"
elif [ "$environment" == "testnet" ]; then
	passwordFile="share-testnet/wallet/password.txt"
else
	passwordFile="share-testnet4/wallet/password.txt"
fi

if [ ! -f "$passwordFile" ]; then
    echo "Generated new LND wallet password!"
	lndPassword=$(tr -dc 'A-F0-9' < /dev/urandom | head -c64)
	printf "${lndPassword}" > "${passwordFile}"
fi

echo "Setup complete! Running docker-compose..."

# Run compose-mainnet.sh for mainnet and compose-testnet.sh for testnet environment
if [ "$environment" == "mainnet" ]; then
	bash start-mainnet.bash
elif [ "$environment" == "testnet" ]; then
	bash start-testnet.bash
else
	bash start-testnet4.bash
fi
