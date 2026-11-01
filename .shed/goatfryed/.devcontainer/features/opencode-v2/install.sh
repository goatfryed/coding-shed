#!/usr/bin/env bash
set -euo pipefail

: ${VERSION:=latest}

TARGET_USER="${_REMOTE_USER:-root}"
TARGET_HOME="$(getent passwd "${TARGET_USER}" | cut -d: -f6)"

install_args=()
if [[ "${VERSION}" != "latest" ]]; then
    install_args+=("--version" "${VERSION}")
fi

chown "$TARGET_USER": "$TARGET_HOME"

if [[ ${#install_args[@]} -gt 0 ]]; then
    su - "${TARGET_USER}" -c "curl -fsSL https://opencode.ai/v2/install | bash -s -- ${install_args[*]@Q}"
else
    su - "${TARGET_USER}" -c "curl -fsSL https://opencode.ai/v2/install | bash"
fi