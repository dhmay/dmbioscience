#!/bin/bash
# Regenerate the website's logo and icon files from the sources in design/.
# Run after editing dmbioscience_logo.svg (or the favicon/og-image sources):
#   ./design/build-assets.sh
set -euo pipefail

INKSCAPE="${INKSCAPE:-/Applications/Inkscape.app/Contents/MacOS/inkscape}"
cd "$(dirname "$0")/.."
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Web copy of the logo, stripped of Inkscape editing data.
"$INKSCAPE" design/dmbioscience_logo.svg --vacuum-defs --export-plain-svg \
  --export-filename=assets/img/logo.svg

# Browser tab icon (SVG for modern browsers, .ico fallback at the site root).
"$INKSCAPE" design/favicon-source.svg --export-plain-svg --export-filename=favicon.svg
"$INKSCAPE" design/favicon-source.svg --export-type=png --export-width=32 \
  --export-filename="$TMP/favicon-32.png"
# An .ico is just a small header wrapped around the PNG.
python3 -c '
import struct, sys
png = open(sys.argv[1], "rb").read()
ico = struct.pack("<HHH", 0, 1, 1) + struct.pack("<BBBBHHII", 32, 32, 0, 0, 1, 32, len(png), 22) + png
open("favicon.ico", "wb").write(ico)
' "$TMP/favicon-32.png"

# iPhone/iPad home-screen icon: opaque white square with padding, since iOS
# rounds the corners itself.
cat > "$TMP/touch.svg" <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="180" height="180" viewBox="0 0 180 180">
  <rect width="180" height="180" fill="#ffffff"/>
  <!--LOGO x="20" y="20" width="140" height="140"-->
</svg>
EOF
python3 design/embed.py favicon.svg "$TMP/touch.svg" "$TMP/touch-full.svg"
"$INKSCAPE" "$TMP/touch-full.svg" --export-type=png --export-width=180 \
  --export-background=white --export-background-opacity=1 \
  --export-filename=apple-touch-icon.png

# Link-preview image (1200x630).
python3 design/embed.py assets/img/logo.svg design/og-image.svg "$TMP/og.svg"
"$INKSCAPE" "$TMP/og.svg" --export-type=png --export-width=1200 \
  --export-background=white --export-background-opacity=1 \
  --export-filename=assets/img/og-image.png

# Email signature logo: 400px wide, displayed at 200px (2x for sharp screens).
"$INKSCAPE" design/dmbioscience_logo.svg --export-type=png --export-width=400 \
  --export-background=white --export-background-opacity=1 \
  --export-filename=design/logo-email-signature.png

echo "Done."
