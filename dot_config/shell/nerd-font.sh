#!/usr/bin/env bash
set -euo pipefail

FONT="JetBrainsMono"
URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT}.tar.xz"

case "$(uname -s)" in
Darwin) DEST="$HOME/Library/Fonts/${FONT}NerdFont" ;;
Linux) DEST="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/${FONT}NerdFont" ;;
*)
  echo "Unsupported OS: $(uname -s)" >&2
  exit 1
  ;;
esac

need() { command -v "$1" >/dev/null 2>&1 || {
  echo "Missing dependency: $1" >&2
  exit 1
}; }
need curl
need tar
[ "$(uname -s)" = Linux ] && need xz

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Downloading ${FONT} Nerd Font..."
curl -fL --progress-bar "$URL" -o "$tmp/font.tar.xz"

mkdir -p "$tmp/extract"
tar -xJf "$tmp/font.tar.xz" -C "$tmp/extract"

# Clean install so old versions don't linger alongside new ones
rm -rf "$DEST"
mkdir -p "$DEST"
find "$tmp/extract" -name '*.ttf' -exec cp {} "$DEST/" \;

count=$(find "$DEST" -name '*.ttf' | wc -l | tr -d ' ')
echo "Installed ${count} font files to $DEST"

if command -v fc-cache >/dev/null 2>&1; then
  echo "Refreshing font cache..."
  fc-cache -f "$DEST" >/dev/null
fi

echo "Done. Set your terminal font to \"JetBrainsMono Nerd Font\" (or \"JetBrainsMono Nerd Font Mono\" for strict single-width icons)."
