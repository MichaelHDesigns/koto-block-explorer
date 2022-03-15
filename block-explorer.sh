#!/bin/bash

echo "downloading part2"
echo

#wget https://raw.githubusercontent.com/MichaelHDesigns/hth-block-explorer/master/block-explorer-part2.sh

echo "---------------"
# Install koto dependencies:

echo "installing hth"
echo

#source ./installer/ubuntu.sh
sudo apt update -y # && sudo apt -y upgrade
sudo apt install -y wget curl git
sudo apt install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils dh-autoreconf
sudo apt install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev

# If you don't have enough RAM (i.e. on Digital Ocean) you'll get an error like this:
  # "g++: internal compiler error: Killed (program cc1plus)"
  # so it's best to just go ahead and allocate some swap before the compile
  # truncate -s 2048M /tmp.swap
  sudo fallocate -l 2G ./tmp.swap
  sudo mkswap ./tmp.swap
  sudo chmod 0600 ./tmp.swap
  sudo swapon ./tmp.swap

# download koto source
git clone https://github.com/HTHcoin/helpthehomelesscoin.git && cd helpthehomelesscoin && PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g') && sudo bash -c "echo 0 > /proc/sys/fs/binfmt_misc/status" && cd depends && make -j7 && cd .. && ./autogen.sh && ./configure --prefix=/ --with-gui=no --with-incomplete-bdb --disable-tests && make -j7

echo "---------------"
echo "installing node and npm"
echo

# install node and dependencies
cd ..
sudo apt-get -y install npm

echo "---------------"
echo "installing nvm"
echo

# install nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

echo "logout of this shell, log back in and run:"
echo "bash block-explorer-part2.sh"
