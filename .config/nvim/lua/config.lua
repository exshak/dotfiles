-- colorizer {{{1
require('colorizer').setup()

-- telescope {{{1
local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      }
    }
  }
}

-- treesitter {{{1
require('nvim-treesitter.configs').setup {
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

-- which-key {{{1
require('which-key').setup {
  show_help = false
}
-- }}}
