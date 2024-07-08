#!/bin/bash

set -e

cd /work/live
lb build
mv *.iso /output
