#!/bin/bash
VERSION="v0.20.1-beta"
SRC="https://github.com/lightningnetwork/lnd/archive/refs/tags/${VERSION}.tar.gz"
echo $SRC
wget -O package.tar.gz $SRC
rm -r .src
mkdir .src
tar xzf package.tar.gz --strip-components 1 -C .src
rm package.tar.gz
