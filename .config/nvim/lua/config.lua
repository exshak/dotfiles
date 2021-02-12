-- treesitter {{{1
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "comment",
    "javascript",
    "python",
    "typescript",
  },
  highlight = {
    enable = true
  },
  playground = {
    enable = true
  }
}
-- }}}
