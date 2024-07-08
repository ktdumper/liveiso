FROM debian:bookworm

COPY src /work

RUN apt-get update; apt-get install -y live-build
