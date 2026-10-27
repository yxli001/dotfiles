#!/bin/sh
set -eu

command -v nvim >/dev/null 2>&1 || exit 0
# Link bundled treesitter queries into site/ *before* Lazy restore starts
# nvim: nvim-treesitter main only links each language's queries when its
# parser is installed (asynchronously), while LazyVim's FileType autocmd fires
# on the opening FileType event — the very first start after a fresh site/
# would otherwise find no queries on the runtimepath.
#
# The plugin checkouts must exist first (Lazy restore creates them), so run
# the link pass twice: before restore to cover an already-populated lazy dir
# (the common re-run case) and again after restore for a bootstrap from empty.
# Idempotent: only creates symlinks that do not already exist.
link_ts_queries() {
  site_queries="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/queries"
  plugins="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy"
  for src in "$plugins/nvim-treesitter/runtime/queries" "$plugins/nvim-treesitter-textobjects/queries"; do
    [ -d "$src" ] || continue
    for lang_dir in "$src"/*; do
      [ -d "$lang_dir" ] || continue
      lang=${lang_dir##*/}
      mkdir -p "$site_queries/$lang"
      for f in "$lang_dir"/*.scm; do
        [ -e "$f" ] || continue
        dst="$site_queries/$lang/${f##*/}"
        [ -e "$dst" ] || ln -s "$f" "$dst"
      done
    done
  done
}
link_ts_queries
nvim --headless "+Lazy! restore" +qa || true
link_ts_queries
