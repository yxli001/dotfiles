-- Pin the treesitter plugins to their `master` branches.
--
-- `master` works with both runtimes here: Mac's Neovim 0.12.3 and Orion's
-- 0.11.6. `main` (the rewrite) requires Neovim >= 0.12 plus tree-sitter-cli
-- >= 0.26.1, which Mac's toolchain doesn't have and Orion's 0.11.6 is below.
-- Commit SHAs stay pinned by .config/nvim/lazy-lock.json.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "master",
  },
}
