-- colorizer {{{1
require('colorizer').setup()

-- completion {{{1
require('compe').setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  }
}

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
