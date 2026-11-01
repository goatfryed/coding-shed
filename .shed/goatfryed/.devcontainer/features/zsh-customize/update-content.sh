#!/usr/bin/env zsh
set -eu

cat << 'EOF' >> $HOME/.zshenv
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.local/state"
export XDG_RUNTIME_DIR="/tmp/xdg-runtime"
EOF
source $HOME/.zshenv

## configure .zshrc
ZSHRC="$HOME/.zshrc"
sed -i \
  -e 's/^ZSH_THEME=".*"/ZSH_THEME="gentoo"/' \
  -e 's/^plugins=(.*)/plugins=(git rust colored-man-pages zsh-autosuggestions zsh-syntax-highlighting)/' \
  "$ZSHRC"

## completions not bundles with oh-my-zsh
: "${ZSH_CUSTOM:=$HOME/.oh-my-zsh/custom}"

mkdir -p "$ZSH_CUSTOM/completions"

cat <<'EOF' > "$ZSH_CUSTOM/completions.zsh"
if [[ -d "$ZSH_CUSTOM/completions" ]]; then
    fpath=("$ZSH_CUSTOM/completions" $fpath)
fi
EOF
chmod 644 "$ZSH_CUSTOM/completions.zsh"

if command -v bun >/dev/null 2>&1; then
    SHELL=zsh bun completions > "$ZSH_CUSTOM/completions/_bun" 2>/dev/null || true
fi

if command -v opencode >/dev/null 2>&1; then
    opencode --completions zsh > "$ZSH_CUSTOM/completions/_opencode" 2>/dev/null || true
fi

chmod 644 "$ZSH_CUSTOM/completions"/_*(N) 2>/dev/null || true

rm -f ${ZSH_COMPDUMP:-${ZDOTDIR:-$HOME}/.zcompdump}*(N)
autoload -Uz compinit
compinit