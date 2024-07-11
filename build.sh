#!/bin/bash

set -e

mkdir -p output tmp

docker build -t ktdumperliveiso:latest .
docker run -it --privileged --rm -v $(realpath output):/output -v $(realpath tmp):/root/.cache/ccache -v $(realpath tmp):/debtmp ktdumperliveiso:latest bash /work/01-build-linux.sh
docker run -it --privileged --rm -v $(realpath output):/output -v $(realpath tmp):/root/.cache/ccache -v $(realpath tmp):/debtmp ktdumperliveiso:latest bash /work/02-build.sh

ls -lah output
