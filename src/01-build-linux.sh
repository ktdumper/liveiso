#!/bin/bash

set -e

cd /work

rm -f /debtmp/*.deb

apt-get source linux
cd linux-*

# add the new usbhack-amd64 kernel flavour
sed -i "s/flavours:/flavours:\n usbhack-amd64/g" debian/config/amd64/none/defines
printf "[usbhack-amd64_image]\nconfigs:\n amd64/config.usbhack\n\n[usbhack-amd64_build]\n\nsigned-code: false\n" >> debian/config/amd64/none/defines
printf "[usbhack-amd64_description]\nhardware: x86-64 usbhack\nhardware-long: x86-64 usbhack\n" >> debian/config/amd64/defines
printf "CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=n\nCONFIG_DEBUG_INFO_NONE=y\n" > debian/config/amd64/config.usbhack
debian/bin/gencontrol.py

patch -p1 < /work/disable-usb-checks-allow-high-wlength.patch
fakeroot make -f debian/rules.gen binary-arch_amd64_none_usbhack-amd64 -j$(nproc)

cp ../*.deb /debtmp
