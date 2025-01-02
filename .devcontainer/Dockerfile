FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
    && apt install -y \
    clang \
    clangd \
    cmake \
    curl \
    file \
    gdb \
    git \
    make \
    wget

ENTRYPOINT [ "/bin/bash" ]