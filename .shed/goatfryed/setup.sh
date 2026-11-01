#!/usr/bin/env bash
set -euo pipefail

shed_dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
owner="$(basename "$shed_dir")"

cd "$shed_dir/../.."

link_artifact() {
  target=$1
  if [[ ! -e "$target" || -L "$target" ]]; then
    ln -sfn "$(realpath -sm --relative-to="$(dirname "$target")" "$shed_dir/$target")" "$target"
    echo "linked $owner's $target"
  else
    echo "Skipping: "$target" is a real directory or file"
  fi
}

link_artifact ".agents/skills"
link_artifact ".opencode"
link_artifact ".devcontainer"

# We copy AGENTS.md, because sym link breaks opencode's caching and auto refresh
target="AGENTS.md"
source="$shed_dir/AGENTS.tmpl.md"
if [[ ! -f "$target" || -n $FORCE ]]; then
    cp "$source" "$target"
    echo "Created $target"
elif ! cmp -s "$source" "$target"; then
    echo "WARNING: '$target' already exists with local modifications!" >&2
    echo "Delete or compare manually $source"
else
    echo "$target up-to-date"
fi
