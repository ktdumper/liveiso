#!/bin/bash

set -e

. "$HOME/.cargo/env"

cd /work

wget https://github.com/tuna-f1sh/cyme/archive/8455975aed640c3a3bdeea86714e78d710e38c43.zip
unzip 8455975aed640c3a3bdeea86714e78d710e38c43.zip
cd cyme-*
cargo build --release
mkdir -p /work/live/config/includes.chroot/usr/bin
cp ./target/release/cyme /work/live/config/includes.chroot/usr/bin

apt-get source libqtermwidget5-1
cd qtermwidget-1.2.0/pyqt
export DEB_PYTHON_INSTALL_LAYOUT=deb
sed -i "s:qtermwidget.h:qtermwidget5/qtermwidget.h:g" sip/qtermwidget.sip
sip-wheel --verbose
cp *.whl /work/live/config/includes.chroot/root/

cd /work/live
lb build
mv *.iso /output
