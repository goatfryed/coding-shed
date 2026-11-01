#!/usr/bin/env bash
set -euo pipefail

script_dir=$(dirname $0)

# Ensure mount paths exist and enforce ownership
sudo chown developer:developer \
    /home/developer/.cargo/ \
    /home/developer/.local/ \
    /home/developer/.local/share \
    /home/developer/.local/share/*

if [[ -x "$script_dir/update-content.local.sh" ]]; then
  "$script_dir/update-content.local.sh"
fi
