#!/bin/bash

set -e

update-ccache-symlinks
export PATH="/usr/lib/ccache/:$PATH"
export MAKEFLAGS="-j$(($(nproc)*2))"
. "$HOME/.cargo/env"

ccache --set-config=max_size=50G

cd /work

apt-get source linux
cd linux-*
sed -i "s/CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y/CONFIG_DEBUG_INFO_NONE=y/g" debian/config/config
patch -p1 < /work/disable-usb-checks-allow-high-wlength.patch
fakeroot make -f debian/rules.gen setup_amd64_none_amd64
fakeroot debian/rules source
fakeroot make -f debian/rules.gen binary-arch_amd64_none_amd64

apt-get source libusb-1.0
cd libusb-1.0-*
sed -i "s/#define MAX_CTRL_BUFFER_LENGTH.*4096/#define MAX_CTRL_BUFFER_LENGTH 73728/g" libusb/os/linux_usbfs.h
sed -i 's|#include "version.h"|#include "version.h"\n#include "os/linux_usbfs.h"\n#define XSTRINGIFY(x) STRINGIFY(x)\n#define STRINGIFY(x) #x|g' libusb/core.c
sed -i 's|LIBUSB_RC, "http://libusb.info"|LIBUSB_RC, "http://libusb.info; MAX_CTRL_BUFFER_LENGTH=" XSTRINGIFY(MAX_CTRL_BUFFER_LENGTH)|g' libusb/core.c
DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -b

mkdir -p /work/live/config/packages.chroot
cp ../*.deb /work/live/config/packages.chroot

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
