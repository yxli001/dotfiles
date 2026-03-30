#!/bin/sh
set -eu

command -v nvim >/dev/null 2>&1 || exit 0
nvim --headless "+Lazy! restore" +qa || true
