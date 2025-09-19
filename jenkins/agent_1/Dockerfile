FROM jenkins/ssh-agent:latest

USER root

# Install required packages
RUN apt-get update && \
    apt-get install -y \
        git \
        cmake \
        build-essential \
        gcc-arm-none-eabi \
        libnewlib-arm-none-eabi \
        ninja-build \
        python3 \
        python3-pip \
        make \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

USER jenkins
