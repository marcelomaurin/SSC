#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
APP="ssc3"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$ROOT_DIR/src"
BUILD_DIR="$ROOT_DIR/.build/ssc3-deb"
OUT_DIR="$ROOT_DIR/bin/lin_bin"

case "$(uname -m)" in
  x86_64) ARCH="amd64" ;;
  i386|i686) ARCH="i386" ;;
  aarch64|arm64) ARCH="arm64" ;;
  armv7l|armv6l|arm) ARCH="armhf" ;;
  *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

command -v lazbuild >/dev/null 2>&1 || { echo "lazbuild not found." >&2; exit 1; }
command -v dpkg-deb >/dev/null 2>&1 || { echo "dpkg-deb not found." >&2; exit 1; }

if [ ! -x "$SRC_DIR/ssc" ]; then
  echo "[SSC] Building Analyzer..."
  lazbuild "$SRC_DIR/ssc.lpi"
fi

[ -f "$SRC_DIR/ssc" ] || { echo "Executable not found: $SRC_DIR/ssc" >&2; exit 1; }

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/DEBIAN" "$BUILD_DIR/usr/bin" "$BUILD_DIR/usr/share/applications" "$BUILD_DIR/usr/share/icons/hicolor/128x128/apps" "$BUILD_DIR/usr/share/doc/$APP" "$OUT_DIR"

install -m 0755 "$SRC_DIR/ssc" "$BUILD_DIR/usr/bin/$APP"
if [ -f "$SRC_DIR/ssc2.png" ]; then
  install -m 0644 "$SRC_DIR/ssc2.png" "$BUILD_DIR/usr/share/icons/hicolor/128x128/apps/ssc3.png"
fi
install -m 0644 "$ROOT_DIR/README.md" "$BUILD_DIR/usr/share/doc/$APP/README.md"
install -m 0644 "$ROOT_DIR/LICENSE" "$BUILD_DIR/usr/share/doc/$APP/LICENSE"

cat > "$BUILD_DIR/DEBIAN/control" <<EOF
Package: ssc3
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Maintainer: Maurinsoft <https://maurinsoft.com.br>
Depends: libc6
Description: SSC Serial Analyzer
 Serial communication analyzer for monitoring, transmitting and diagnosing
 serial/USB devices. Part of the SSC serial-over-TCP project.
EOF

cat > "$BUILD_DIR/usr/share/applications/ssc3.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=SSC Serial Analyzer
Comment=Serial/USB communication analyzer
Exec=/usr/bin/ssc3
Icon=ssc3
Terminal=false
Categories=Development;Utility;
EOF

OUT="$OUT_DIR/ssc3_${VERSION}_${ARCH}.deb"
dpkg-deb --build "$BUILD_DIR" "$OUT"
echo "[SSC] Created: $OUT"
