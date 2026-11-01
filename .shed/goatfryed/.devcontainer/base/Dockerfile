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

RUN mkdir -p /home/developer/.local/share \
    && chown -R 1000:1000 /home/developer/.local

USER developer

WORKDIR /workspace
