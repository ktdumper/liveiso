#!/bin/bash

set -e

update-ccache-symlinks
export PATH="/usr/lib/ccache/:$PATH"
export MAKEFLAGS="-j$(($(nproc)*2))"
. "$HOME/.cargo/env"

ccache --set-config=max_size=50G

cd /work

rm -f /debtmp/*.deb

apt-get source linux
cd linux-*
sed -i "s/CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y/CONFIG_DEBUG_INFO_NONE=y/g" debian/config/config
patch -p1 < /work/disable-usb-checks-allow-high-wlength.patch
fakeroot make -f debian/rules.gen setup_amd64_none_amd64
fakeroot debian/rules source
fakeroot make -f debian/rules.gen binary-arch_amd64_none_amd64

cp ../*.deb /debtmp
