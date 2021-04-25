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

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {noremap = true, silent = true}
  buf_set_keymap('n', 'K', '<cmd>Lspsaga hover_doc<cr>', opts)
  buf_set_keymap('n', 'gd', '<cmd>Lspsaga preview_definition<cr>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  buf_set_keymap('n', 'gr', '<cmd>Lspsaga lsp_finder<cr>', opts)
  buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_set_keymap('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<cr>', opts)
  buf_set_keymap('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<cr>', opts)
  buf_set_keymap('n', '<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<cr>', opts)
  buf_set_keymap('n', '<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<cr>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>Lspsaga signature_help<cr>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>Lspsaga code_action<cr>', opts)
  buf_set_keymap('n', '<leader>ed', '<cmd>Lspsaga show_line_diagnostics<cr>', opts)
  buf_set_keymap('n', '<leader>fa', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>Lspsaga rename<cr>', opts)
end

local eslint = {
  lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
  lintFormats = {'%f:%l:%c: %m'},
  lintIgnoreExitCode = true,
  lintStdin = true
}

local prettier = {
  formatCommand = 'prettier --find-config-path --stdin-filepath ${INPUT}',
  formatStdin = true
}

local flake8 = {
  lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
  lintFormats = {'%f:%l:%c: %m'},
  lintStdin = true
}

local black = {
  formatCommand = 'black --quiet -',
  formatStdin = true
}

local shellcheck = {
  lintCommand = 'shellcheck -f gcc -x',
  lintSource = 'shellcheck',
  lintFormats = {
    '%f:%l:%c: %trror: %m',
    '%f:%l:%c: %tarning: %m',
    '%f:%l:%c: %tote: %m'
  }
}

local shfmt = {
  formatCommand = 'shfmt -i 2 -ci -s -bn -sr -kp',
  formatStdin = true
}

local luaformat = {
  formatCommand = 'lua-format -i',
  formatStdin = true
}

local efm_settings = {
  rootMarkers = {'.git/'},
  languages = {
    javascript = {eslint, prettier},
    typescript = {eslint, prettier},
    javascriptreact = {eslint, prettier},
    typescriptreact = {eslint, prettier},
    python = {flake8, black},
    sh = {shellcheck, shfmt},
    lua = {luaformat}
  }
}

local lua_settings = {
  Lua = {
    runtime = {
      version = 'LuaJIT',
      path = vim.split(package.path, ';')
    },
    diagnostics = {
      globals = {'vim'}
    },
    workspace = {
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
      }
    }
  }
}

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    capabilities = capabilities,
    on_attach = on_attach
  }
end

lspinstall.setup()

local servers = lspinstall.installed_servers()
for _, server in pairs(servers) do
  local config = make_config()

  if server == 'efm' then
    config.init_options = {documentFormatting = true}
    config.settings = efm_settings
  end

  if server == 'lua' then
    config.settings = lua_settings
  end

  if server == 'typescript' then
    config.on_attach = function(client)
      client.resolved_capabilities.document_formatting = false
      on_attach(client)
    end
  end

  lspconfig[server].setup(config)
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
