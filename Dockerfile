# Dockerfile.base
FROM ubuntu:20.04

# Cài dependencies cần thiết để chạy OpenWRT SDK
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    make \
    libncurses5-dev \
    python3 \
    python3-distutils \
    rsync \
    unzip \
    wget \
    file \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy SDK đã tải sẵn vào image
COPY openwrt-sdk-23.05.3-bcm27xx-bcm2711_gcc-12.3.0_musl.Linux-x86_64/ /openwrt-sdk/

# Set PATH để dùng toolchain
ENV PATH="/openwrt-sdk/staging_dir/toolchain-aarch64_cortex-a72_gcc-12.3.0_musl/bin:${PATH}"
ENV STAGING_DIR="/openwrt-sdk/staging_dir"

WORKDIR /build
