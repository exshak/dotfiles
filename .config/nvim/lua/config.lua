-- colorizer {{{1
require('colorizer').setup()

-- completion {{{1
require('compe').setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'always',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
    ultisnips = true
  }
}

-- lspconfig {{{1
local lspconfig = require('lspconfig')
local lspinstall = require('lspinstall')

lspinstall.setup()

local servers = lspinstall.installed_servers()
for _, server in pairs(servers) do
  lspconfig[server].setup()
end

-- lspsaga {{{1
local saga = require('lspsaga')

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  code_action_icon = '💡',
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 20,
    virtual_text = false
  },
  code_action_keys = {
    quit = {'q', '<esc>'},
    exec = '<cr>'
  },
  rename_action_keys = {
    quit = {'<C-c>', '<esc>'},
    exec = '<cr>'
  }
}

-- telescope {{{1
local actions = require('telescope.actions')

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<esc>'] = actions.close
      }
    }
  }
}

-- treesitter {{{1
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'comment',
    'javascript',
    'lua',
    'python',
    'typescript'
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
