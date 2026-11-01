FROM debian:trixie-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    pkg-config \
    zstd \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    libasound2-dev \
    libasound2-plugins \
    libegl1 \
    libfontconfig1-dev \
    libvulkan-dev \
    libvulkan1 \
    libwayland-dev \
    libxext6 \
    libxkbcommon-dev \
    mesa-vulkan-drivers \
    vulkan-tools \
    wayland-protocols \
    && cp /etc/alsa/conf.d/99-pulseaudio-default.conf.example /etc/alsa/conf.d/99-pulseaudio-default.conf \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    clang \
    libudev-dev \
    mold \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    libdecor-0-0 \
    libgl1 \
    libgl1-mesa-dri \
    libsm6 \
    libwayland-client0 \
    libwayland-cursor0 \
    libx11-6 \
    libxxf86vm1 \
    libxfixes3 \
    libxi6 \
    libxkbcommon0 \
    libxrender1 \
    && rm -rf /var/lib/apt/lists/*

ENV RUSTFLAGS="-C link-arg=-fuse-ld=mold"

RUN mkdir -p /home/developer/.local/share \
    && chown -R 1000:1000 /home/developer/.local

USER developer

WORKDIR /workspace
