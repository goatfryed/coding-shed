#!/usr/bin/env bash
set -euo pipefail

VERSION="${VERSION:-0.20.0}"
ARCHIVE="jackdaw-x86_64-unknown-linux-gnu.tar.zst"
SHA256="7631de2e34d96c5cb18dddd738cc776e874fe190ff8246746941aa596234d1e6"
BASE_URL="https://github.com/jbuehler23/jackdaw/releases/download/v${VERSION}"
BUNDLE_NAME="jackdaw-x86_64-unknown-linux-gnu"

if [[ "$(uname -m)" != "x86_64" ]]; then
    echo "Jackdaw ${VERSION} supports Linux x86_64 only (found $(uname -m))." >&2
    exit 1
fi

if [[ "$VERSION" != "0.20.0" ]]; then
    echo "Jackdaw ${VERSION} is unsupported: this feature pins release 0.20.0 and its checksum." >&2
    exit 1
fi

if [[ "$(id -u)" -ne 0 ]]; then
    echo "Jackdaw feature installation must run as root." >&2
    exit 1
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
archive_path="$tmpdir/$ARCHIVE"
install_path="/opt/jackdaw/$VERSION/$BUNDLE_NAME"

curl -fsSL "$BASE_URL/$ARCHIVE" -o "$archive_path"
printf '%s  %s\n' "$SHA256" "$archive_path" | sha256sum --check --status || {
    echo "Checksum verification failed for Jackdaw ${VERSION} archive." >&2
    exit 1
}

mkdir "$tmpdir/extracted"
zstd -dc "$archive_path" | tar -xf - -C "$tmpdir/extracted"
bundle_path="$tmpdir/extracted/$BUNDLE_NAME"
if [[ ! -d "$bundle_path" || ! -x "$bundle_path/jackdaw" || ! -x "$bundle_path/jd" ]]; then
    echo "Jackdaw archive is missing the expected $BUNDLE_NAME executables." >&2
    exit 1
fi

mkdir -p "$(dirname "$install_path")"
rm -rf "$install_path"
mv "$bundle_path" "$install_path"
ln -sfn "$install_path/jackdaw" /usr/local/bin/jackdaw
ln -sfn "$install_path/jd" /usr/local/bin/jd
