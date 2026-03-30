#!/bin/sh
set -eu

if [ -x "$HOME/.local/bin/starship" ] || command -v starship >/dev/null 2>&1; then
  exit 0
fi

curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
