#!/usr/bin/env bash
set -euo pipefail

script_dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
workspace_root="$(realpath "$script_dir/../../..")"

opencode_data_dir="${XDG_DATA_HOME:=$HOME/.local/share}/opencode"
opencode_config_dir="${XDG_CONFIG_HOME:=$HOME/.config}/opencode"

sudo mkdir -p /etc/opencode
sudo chmod 755 /etc/opencode

etc_config="$workspace_root/.secrets/etc.opencode.jsonc"
if [[ -f "$etc_config" ]]; then
  sudo cp "$etc_config" /etc/opencode/opencode.jsonc
  sudo chmod 644 /etc/opencode/opencode.jsonc
  echo "[opencode-setup] setup /etc/opencode/opencode.jsonc"
fi

sudo chown -R root:root /etc/opencode

echo "[opencode-setup] Done."