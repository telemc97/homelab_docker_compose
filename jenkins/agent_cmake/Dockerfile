FROM jenkins/ssh-agent:latest

USER root

# Install CMake + Make + GCC/G++ + ARM cross-compiler
RUN apt-get update && \
    apt-get install -y \
        cmake \
        build-essential \
        gcc-arm-none-eabi \
        libnewlib-arm-none-eabi && \
    rm -rf /var/lib/apt/lists/*

USER jenkins