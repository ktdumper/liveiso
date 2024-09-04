FROM debian:bookworm

RUN sed -i "s/Types: deb/Types: deb deb-src/g" /etc/apt/sources.list.d/debian.sources
RUN apt-get update
RUN apt-get install -y live-build dpkg-dev sip-tools python3-pyqtbuild pyqt5-dev python3-dev libqtermwidget5-1-dev wget curl unzip build-essential fakeroot
RUN apt-get build-dep -y libqtermwidget5-1-dev libusb-1.0 linux
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --default-toolchain=1.79.0

COPY src /work
