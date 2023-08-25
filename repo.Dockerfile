FROM ubuntu:22.04

RUN apt update && apt upgrade -y && apt install rsync repo -y

WORKDIR /workspace
