#!/bin/bash

echo "downloading part2"
echo

#wget https://raw.githubusercontent.com/wo01/koto-block-explorer/master/block-explorer-part2.sh

echo "---------------"
# Install koto dependencies:

echo "installing koto"
echo

sudo apt-get -y install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake curl

# download koto source
git clone https://github.com/KotoDevelopers/koto.git

cd koto

# apply bitcore patch
git checkout v1.1.0
patch -p1 < ./zcutil/bitcore.diff

# download proving parameters
./zcutil/fetch-params.sh

# build patched koto
./zcutil/build.sh -j 2

# install lintian
sudo apt-get -y install lintian

# package koto
./zcutil/build-debian-package.sh

# install koto
sudo dpkg -i koto-1.1.0-*.deb

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

