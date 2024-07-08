#!/bin/bash

set -e

mkdir -p output

output=$(realpath output)

docker build -t ktdumperliveiso:latest .
docker run -it --privileged --rm -v $output:/output ktdumperliveiso:latest bash /work/inner-build.sh

ls -lah output
