-- colorizer {{{1
require('colorizer').setup()

-- lspconfig {{{1
local lspconfig = require('lspconfig')

local servers = { 'pyright', 'tsserver', 'vimls' }
for _, server in pairs(servers) do
  lspconfig[server].setup {}
end

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
    "lua",
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
