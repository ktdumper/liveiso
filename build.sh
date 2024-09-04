#!/bin/bash

set -e

mkdir -p output tmp

docker build -t ktdumperliveiso:latest .
docker run --privileged --rm -v $(realpath output):/output -v $(realpath tmp):/debtmp ktdumperliveiso:latest bash /work/01-build-linux.sh
docker run --privileged --rm -v $(realpath output):/output -v $(realpath tmp):/debtmp ktdumperliveiso:latest bash /work/02-build.sh

ls -lah output
