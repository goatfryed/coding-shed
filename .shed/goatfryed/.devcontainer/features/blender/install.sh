#!/usr/bin/env bash
set -euo pipefail

BLENDER_VERSION="${VERSION:-5.2.3}"
BLENDER_SERIES="${BLENDER_VERSION%.*}"
RELEASE_URL="https://download.blender.org/release/Blender${BLENDER_SERIES}"
TARBALL="blender-${BLENDER_VERSION}-linux-x64.tar.xz"
INSTALL_DIR="/opt/blender"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Installing v${BLENDER_VERSION} from ${RELEASE_URL}/${TARBALL}"
curl -fsSL "${RELEASE_URL}/${TARBALL}" -o "${TMP_DIR}/${TARBALL}"
curl -fsSL "${RELEASE_URL}/blender-${BLENDER_VERSION}.sha256" -o "${TMP_DIR}/blender.sha256"

# verify src
(cd "$TMP_DIR"; grep "${TARBALL}" blender.sha256 | sha256sum -c -)

mkdir -p "$INSTALL_DIR"
tar -xJ --strip-components=1 -C "$INSTALL_DIR" -f "${TMP_DIR}/${TARBALL}"

BLENDER_WRAPPER=/usr/local/bin/blender
ln -s /opt/blender/blender $BLENDER_WRAPPER

# blender gui in container doesn't work for me
# blender fails with EGL_BAD_ALLOC, unless legacy egl path is forced
# the below wrapper forces this, but then requires group add for specific gpus
# which i dont like, because thats to host specific imho
#config_dir=/usr/local/share/blender-egl-platforms
#
#mkdir -p "$config_dir"
#ln -sfn /usr/share/egl/egl_external_platform.d/10_nvidia_wayland.json \
#  "$config_dir/10_nvidia_wayland.json"
#
#cat > "$BLENDER_WRAPPER" <<EOF
##!/usr/bin/env bash
#set -euo pipefail
#
#export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json
#export __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS="$config_dir"
#
#exec /opt/blender/blender "\$@"
#EOF
#
#chmod +x "$BLENDER_WRAPPER"