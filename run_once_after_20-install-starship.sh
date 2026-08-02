#!/bin/sh
set -eu

# Starship
if [ ! -x "$HOME/.local/bin/starship" ] && ! command -v starship >/dev/null 2>&1; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
fi

# install a nerd font
FONT_NAME="JetBrainsMono"

case "$(uname -s)" in
  Darwin)
    FONT_DIR="$HOME/Library/Fonts/${FONT_NAME}NerdFont"
    ;;
  Linux)
    FONT_DIR="$HOME/.local/share/fonts/${FONT_NAME}NerdFont"
    ;;
  *)
    echo "Unsupported OS for font install: $(uname -s). Please install a nerd font manually." >&2
    exit 0
    ;;
esac

if [ ! -d "$FONT_DIR" ]; then
  mkdir -p "$FONT_DIR"
  TMP_ZIP="$(mktemp)"
  curl -sSL -o "$TMP_ZIP" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
  unzip -oq "$TMP_ZIP" -d "$FONT_DIR"
  rm -f "$TMP_ZIP"

  if [ "$(uname -s)" = "Linux" ] && command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$FONT_DIR" >/dev/null 2>&1
  fi
fi
