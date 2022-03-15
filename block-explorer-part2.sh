#!/bin/bash

echo "switching to correct node version"
echo

# nvm setup

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm


# switch node setup with nvm
nvm install v7

echo "---------------"
echo "installing bitcore dependencies"
echo

# install zeromq
sudo apt-get -y install libzmq3-dev

echo "---------------"
echo "installing koto patched bitcore"
echo 
npm install MichaelHDesigns/bitcore-node-hth

echo "---------------"
echo "setting up bitcore"
echo

# setup bitcore
./node_modules/bitcore-node-hth/bin/bitcore-node create hth-explorer

cd hth-explorer


echo "---------------"
echo "installing insight UI"
echo

../node_modules/bitcore-node-hth/bin/bitcore-node install HTHcoin/insight-api HTHcoin/insight-ui


echo "---------------"
echo "creating config files"
echo

# point koto at mainnet
cat << EOF > bitcore-node.json
{
  "network": "mainnet",
  "port": 3001,
  "services": [
    "helpthehomelessd",
    "insight-api",
    "insight-ui",
    "web"
  ],
  "servicesConfig": {
    "helpthehomelessd": {
      "spawn": {
        "datadir": "./data",
        "exec": "helpthehomelessd"
      }
    },
    "insight-ui": {
      "routePrefix": "",
      "apiPrefix": "api"
    },
    "insight-api": {
      "routePrefix": "api"
    }
  }
}

EOF

# create koto.conf
cat << EOF > data/helpthehomeless.conf
server=1
whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://127.0.0.1:8332
zmqpubhashblock=tcp://127.0.0.1:8332
rpcallowip=127.0.0.1
rpcuser=bitcoin
rpcpassword=local321
uacomment=bitcore
showmetrics=0

EOF


echo "---------------"
# start block explorer
echo "To start the block explorer, from within the hth-explorer directory issue the command:"
echo " nvm use v4; ./node_modules/bitcore-node-hth/bin/bitcore-node start"
