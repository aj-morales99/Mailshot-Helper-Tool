#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
#  Cornerstone Mailshot Tool — macOS App Builder
#  Run this from the folder containing AllInOneTool.py
#  Output: dist/Cornerstone Mailshot.app
#
#  Usage:
#    chmod +x build_app.sh
#    ./build_app.sh
# ─────────────────────────────────────────────────────────────────────────────
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_NAME="Cornerstone Mailshot"
MAIN_SCRIPT="AllInOneTool.py"
ICON_FILE="logo.icns"   # optional — see README for how to convert logo.png

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Building: $APP_NAME"
echo "  Source:   $SCRIPT_DIR/$MAIN_SCRIPT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd "$SCRIPT_DIR"

# ── 1. Install dependencies ───────────────────────────────────────────────────
echo ""
echo "▶ Installing / checking dependencies..."
pip3 install customtkinter requests pillow pyinstaller --quiet

# ── 2. Convert logo.png → .icns if not already done ──────────────────────────
if [ -f "logo.png" ] && [ ! -f "$ICON_FILE" ]; then
  echo "▶ Converting logo.png → $ICON_FILE ..."
  mkdir -p logo.iconset
  sips -z 16   16   logo.png --out logo.iconset/icon_16x16.png    > /dev/null
  sips -z 32   32   logo.png --out logo.iconset/icon_16x16@2x.png > /dev/null
  sips -z 32   32   logo.png --out logo.iconset/icon_32x32.png    > /dev/null
  sips -z 64   64   logo.png --out logo.iconset/icon_32x32@2x.png > /dev/null
  sips -z 128  128  logo.png --out logo.iconset/icon_128x128.png  > /dev/null
  sips -z 256  256  logo.png --out logo.iconset/icon_128x128@2x.png > /dev/null
  sips -z 256  256  logo.png --out logo.iconset/icon_256x256.png  > /dev/null
  sips -z 512  512  logo.png --out logo.iconset/icon_256x256@2x.png > /dev/null
  sips -z 512  512  logo.png --out logo.iconset/icon_512x512.png  > /dev/null
  iconutil -c icns logo.iconset -o "$ICON_FILE"
  rm -rf logo.iconset
  echo "   ✓ Created $ICON_FILE"
fi

# ── 3. Build with PyInstaller ─────────────────────────────────────────────────
echo ""
echo "▶ Running PyInstaller..."

ICON_ARG=""
if [ -f "$ICON_FILE" ]; then
  ICON_ARG="--icon=$ICON_FILE"
fi

# Data files to bundle alongside the app
DATA_ARGS=""
[ -f "config.json" ] && DATA_ARGS="$DATA_ARGS --add-data config.json:."
[ -f "logo.png"    ] && DATA_ARGS="$DATA_ARGS --add-data logo.png:."

pyinstaller \
  --noconfirm \
  --windowed \
  --name "$APP_NAME" \
  $ICON_ARG \
  $DATA_ARGS \
  --hidden-import customtkinter \
  --hidden-import PIL \
  --hidden-import PIL.Image \
  --hidden-import PIL.ImageTk \
  --collect-all customtkinter \
  "$MAIN_SCRIPT"

# ── 4. Post-build: copy config.json next to the .app so it's editable ─────────
if [ -f "config.json" ]; then
  cp config.json "dist/config.json"
  echo ""
  echo "▶ Copied config.json → dist/config.json"
  echo "  Edit dist/config.json to update API keys without rebuilding."
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ Build complete!"
echo "  App: dist/$APP_NAME.app"
echo ""
echo "  To distribute:"
echo "    1. Copy the entire dist/ folder"
echo "    2. Edit dist/config.json for API keys"
echo "    3. Drop logo.png in the same folder as the .app"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
