#!/bin/bash

set -e

mkdir -p output tmp

output=$(realpath output)
tmp=$(realpath tmp)

docker build -t ktdumperliveiso:latest .
docker run -it --privileged --rm -v $output:/output -v $tmp:/root/.cache/ccache ktdumperliveiso:latest bash /work/inner-build.sh

ls -lah output
