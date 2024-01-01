local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazynvim = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", lazynvim, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

-- Default {{{1
-- code {{{2
if vim.g.vscode then
  local opt = vim.opt

  opt.clipboard = "unnamedplus"

  local function map(mode, lhs, rhs, opts)
    mode = vim.split(mode, "")
    opts = opts or {}
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  local function vscode(cmd)
    return function()
      vim.fn.VSCodeNotify(cmd)
    end
  end

  map("nox", "gc", "<Plug>VSCodeCommentary")
  map("n", "gcc", "<Plug>VSCodeCommentaryLine")
  map("n", "<leader><space>", vscode("workbench.action.quickOpen"))

  return
end

-- icons {{{2
local icons = {
  dap = {
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
  },
  diagnostics = {
    Error = "󰅚 ",
    Hint = " ",
    Info = " ",
    Warn = "󰀪 ",
  },
  git = {
    added = "+",
    branch = "",
    delete = "",
    diff = "╱",
    gutter = "▎",
    modified = "~",
    removed = "-",
  },
  kinds = {
    Array = " ",
    Boolean = " ",
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Namespace = " ",
    Null = " ",
    Number = " ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
  },
  mason = {
    installed = "✓",
    pending = "➜",
    uninstalled = "✗",
  },
  telescope = {
    prompt = " ",
    selection = " ",
  },
  whichkey = {
    breadcrumb = "»",
    group = "+",
    separator = "➜",
  },
}

local symbols = {
  "Class",
  "Constructor",
  "Enum",
  "Field",
  "Function",
  "Interface",
  "Method",
  "Module",
  "Namespace",
  "Package",
  "Property",
  "Struct",
  "Trait",
}

-- utils {{{2
local Util = require("lazy.core.util")

local function on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

local function on_rename(from, to)
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/willRenameFiles") then
      local resp = client.request_sync("workspace/willRenameFiles", {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

local function fg(name)
  -- stylua: ignore
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name, link = false }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and (hl.fg or hl.foreground)
  return fg and { fg = string.format("#%06x", fg) } or nil
end

local function float_term(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    size = { width = 0.8, height = 0.8 },
  }, opts or {})
  return function()
    require("lazy.util").float_term(cmd, opts)
  end
end

local function get_line(line)
  line = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
  local commentstring = vim.split(vim.bo.commentstring, "%%s")[1]
  for _, marker in ipairs(vim.split(vim.wo.foldmarker, ",")) do
    line = vim.fn.substitute(line, commentstring .. "\\(.*\\)\\zs" .. marker .. "\\d*", "", "g")
  end
  if commentstring ~= "" then
    line = vim.fn.substitute(line, "^\\s*" .. commentstring, "", "g")
  end
  return line:gsub("^%s+", "")
end

function _G.foldtext()
  local line = get_line(vim.v.foldstart)
  local fold = vim.v.foldend - vim.v.foldstart + 1
  local indent = vim.bo.shiftwidth * (vim.v.foldlevel - 1)
  local width = vim.bo.textwidth > 0 and vim.bo.textwidth or 80
  local fill = width - #line - #tostring(fold) - indent
  local win = vim.api.nvim_get_current_win()
  local pad = vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff - width
  return string.rep(" ", indent) .. line .. string.rep(" ", fill) .. fold .. string.rep(" ", pad)
end

function _G.scratch()
  vim.cmd("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.buflisted = false
  vim.bo.swapfile = false
end

local function get_root()
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    root = vim.fs.find({ ".git", "lua" }, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  return root
end

local function telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    if opts.cwd and opts.cwd ~= vim.loop.cwd() then
      opts.attach_mappings = function(_, map)
        map("i", "<A-c>", function()
          local action_state = require("telescope.actions.state")
          local line = action_state.get_current_line()
          telescope(
            params.builtin,
            vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
          )()
        end, { desc = "Open cwd directory" })
        return true
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

local function toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      Util.info("Enabled " .. option, { title = "Option" })
    else
      Util.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

local enabled = true
local function toggle_diagnostics()
  enabled = not enabled
  if enabled then
    vim.diagnostic.enable()
    Util.info("Enabled diagnostics", { title = "Diagnostics" })
  else
    vim.diagnostic.disable()
    Util.warn("Disabled diagnostics", { title = "Diagnostics" })
  end
end

-- Plugins {{{1
-- * {{{2
local plugins = {
  -- dracula {{{2
  {
    "exshak/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "pro",
      lualine_bold = true,
      on_colors = function(c)
        c.comment = "#6272a4"
        c.selection = "#44475a"
      end,
      on_highlights = function(hl, c)
        hl.CursorLine = { bg = c.none }
      end,
    },
    config = function(_, opts)
      require("dracula").setup(opts)
      vim.cmd("colorscheme dracula")
    end,
  },

  -- tokyonight {{{2
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "moon",
      styles = {
        floats = "transparent",
        sidebars = "transparent",
      },
      transparent = true,
      on_colors = function(c)
        c.bg_statusline = c.none
      end,
      on_highlights = function(hl, c)
        hl.Folded = { bg = c.none, fg = c.comment }
        hl.MiniIndentscopeSymbol = { fg = c.fg_gutter }
      end,
    },
  },

  -- bqf {{{2
  {
    "kevinhwang91/nvim-bqf",
    event = "QuickFixCmdPost",
    opts = {
      preview = {
        border_chars = { "", "", "", "", "", "", "", "", "" },
      },
    },
  },

  -- bufferline {{{2
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bl", ":BufferLineCloseLeft<cr>", desc = "Delete buffers to the left" },
      { "<leader>bo", ":BufferLineCloseOthers<cr>", desc = "Delete other buffers" },
      { "<leader>bp", ":BufferLineTogglePin<cr>", desc = "Toggle pin" },
      { "<leader>bP", ":BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
      { "<leader>br", ":BufferLineCloseRight<cr>", desc = "Delete buffers to the right" },
    },
    opts = {
      options = {
        always_show_bufferline = false,
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error and icons.diagnostics.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.diagnostics.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          { filetype = "DiffviewFiles", highlight = "Normal" },
          { filetype = "neo-tree", highlight = "Normal" },
        },
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        separator_style = { "", "" },
        show_buffer_close_icons = false,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- chatgpt {{{2
  {
    "jackmort/chatgpt.nvim",
    keys = {
      { "<leader>\\", ":ChatGPT<cr>", desc = "ChatGPT" },
    },
    opts = {},
  },

  -- cmp {{{2
  {
    "hrsh7th/nvim-cmp",
    version = false,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
      {
        "zbirenbaum/copilot.lua",
        -- build = ":Copilot auth",
        cmd = "Copilot",
        opts = {
          filetypes = {
            help = true,
            markdown = true,
          },
          panel = { enabled = false },
          suggestion = { enabled = false },
        },
      },
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          local copilot_cmp = require("copilot_cmp")
          copilot_cmp.setup()
          on_attach(function(client)
            if client.name == "copilot" then
              copilot_cmp._on_insert_enter({})
            end
          end)
        end,
      },
    },
    event = "InsertEnter",
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local defaults = require("cmp.config.default")()
      table.insert(defaults.sorting.comparators, 1, require("copilot_cmp.comparators").prioritize)
      return {
        formatting = {
          format = function(entry, item)
            if icons.kinds[item.kind] then
              item.kind = icons.kinds[item.kind] .. item.kind
            end
            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<cr>"] = cmp.mapping.confirm({ select = true }),
          ["<S-cr>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<C-cr>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
          ["<tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sorting = defaults.sorting,
        sources = cmp.config.sources({
          { name = "copilot", group_index = 1, priority = 100 },
          { name = "nvim_lsp", group_index = 1 },
          { name = "luasnip", group_index = 1 },
          { name = "buffer", group_index = 1 },
          { name = "emoji", group_index = 1 },
          { name = "path", group_index = 1 },
        }),
      }
    end,
  },

  -- colorizer {{{2
  {
    "nvchad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      buftype = { "*", "!prompt" },
      filetypes = { "*", "!lazy", "!noice", "!notify" },
      user_default_options = {
        mode = "background",
        names = false,
      },
    },
  },

  -- conflict {{{2
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- copilotchat {{{2
  {
    "copilotc-nvim/copilotchat.nvim",
    branch = "canary",
    keys = {
      { "<leader>aa", ":CopilotChat<cr>", desc = "Copilot chat" },
    },
    opts = {
      separator = " ",
      show_folds = false,
      show_help = false,
    },
  },

  -- cutlass {{{2
  {
    "gbprod/cutlass.nvim",
    event = "VeryLazy",
    opts = {
      cut_key = "d",
      exclude = { "ns", "nS" },
    },
  },

  -- dap {{{2
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason.nvim" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_installation = true,
          ensure_installed = {},
          handlers = {},
        },
      },
      {
        "rcarriga/nvim-dap-ui",
        -- stylua: ignore
        keys = {
          { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
          { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
        },
        -- stylua: ignore
        config = function()
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup()
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end
        end,
      },
      { "thehamsta/nvim-dap-virtual-text", opts = {} },
    },
    -- stylua: ignore
    keys = {
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with args" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint condition" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dq", function() require("dap").close() end, desc = "Close" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
      require("overseer").patch_dap(true)
      require("dap.ext.vscode").json_decode = require("overseer.json").decode
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      for name, sign in pairs(icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end,
  },

  -- dashboard {{{2
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      return {
        config = {
          center = {
            { key = "c", icon = " ", desc = " Config", action = "e $MYVIMRC" },
            { key = "f", icon = " ", desc = " Find", action = "Telescope fd" },
            { key = "g", icon = " ", desc = " Grep", action = "Telescope live_grep" },
            { key = "p", icon = " ", desc = " Project", action = "Telescope projects" },
            { key = "r", icon = " ", desc = " Recent", action = "Telescope frecency" },
            { key = "s", icon = " ", desc = " Session", action = "lua require('persistence').load()" },
            { key = "l", icon = "󰒲 ", desc = " Lazy", action = "Lazy" },
            { key = "q", icon = " ", desc = " Quit", action = "qa" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local time = math.floor(stats.startuptime * 100) / 100
            local ver = vim.version()
            return {
              string.format(" v%d.%d.%d   󰂖 %d   󰔛 %sms", ver.major, ver.minor, ver.patch, stats.count, time),
            }
          end,
        },
        hide = {
          statusline = false,
        },
        preview = {
          command = "cat | bunnyfetch",
          file_path = "",
          file_height = 27,
          file_width = 54,
        },
        theme = "doom",
      }
    end,
    config = function(_, opts)
      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end
      require("dashboard").setup(opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        callback = function(event)
          vim.keymap.set("n", "b", scratch, { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "e", ":Neotree<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "h", ":checkhealth<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "m", ":Mason<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "n", ":enew<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "o", ":ObsidianQuickSwitch<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "t", ":Lazy profile<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "u", ":Lazy update<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "x", ":LazyExtras<cr>", { buffer = event.buf, nowait = true, silent = true })
        end,
      })
    end,
  },

  -- dial {{{2
  {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.constant.alias.bool,
          augend.date.alias["%Y/%m/%d"],
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.semver.alias.semver,
        },
      })
    end,
  },

  -- diffview {{{2
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>dvc", ":DiffviewClose<cr>", desc = "Diffview close" },
      { "<leader>dvo", ":DiffviewOpen<cr>", desc = "Diffview open" },
    },
  },

  -- dressing {{{2
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- escape {{{2
  {
    "max397574/better-escape.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- flash {{{2
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "r", function() require("flash").remote() end, desc = "Remote flash", mode = "o" },
      { "R", function() require("flash").treesitter_search() end, desc = "Treesitter search", mode = { "o", "x" } },
      { "s", function() require("flash").jump() end, desc = "Flash", mode = { "n", "o", "x" } },
      { "S", function() require("flash").treesitter() end, desc = "Flash treesitter", mode = { "n", "o", "x" } },
      { "<C-s>", function() require("flash").toggle() end, desc = "Toggle flash search", mode = { "c" } },
    },
    opts = {
      modes = {
        search = {
          enabled = false,
        },
      },
    },
  },

  -- fsread {{{2
  {
    "nullchilly/fsread.nvim",
    keys = {
      { "<leader>ub", ":FSToggle<cr>", desc = "Toggle bionic reading" },
    },
  },

  -- fugitive {{{2
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    keys = {
      { "<leader>ga", ":Gwrite<cr>", desc = "Add" },
      { "<leader>gb", ":Git blame<cr>", desc = "Blame" },
      { "<leader>gc", ":Git commit<cr>", desc = "Commit" },
      { "<leader>gd", ":Gvdiffsplit<cr>", desc = "Diff" },
      { "<leader>gh", ":GBrowse<cr>", desc = "Browse" },
      { "<leader>gl", ":Git pull<cr>", desc = "Pull" },
      { "<leader>gp", ":Git push<cr>", desc = "Push" },
      { "<leader>gq", ":Gwrite<cr>:Git commit -m 'updated'<cr>:Git push<cr>", desc = "Add/Commit/Push" },
      { "<leader>gr", ":GRemove<cr>", desc = "Remove" },
      { "<leader>gs", ":G<cr>", desc = "Status" },
    },
  },

  -- gitsigns {{{2
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = icons.git.gutter },
        change = { text = icons.git.gutter },
        changedelete = { text = icons.git.gutter },
        delete = { text = icons.git.delete },
        topdelete = { text = icons.git.delete },
        untracked = { text = " " },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          local modes = vim.split(mode, "")
          vim.keymap.set(modes, l, r, { buffer = buffer, desc = desc })
        end
        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff this ~")
        map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk inline")
        map("nv", "<leader>hr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        map("nv", "<leader>hs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map('n', '<leader>tb', gs.toggle_current_line_blame, "Toggle blame line")
        map("ox", "ih", ":<C-u>Gitsigns select_hunk<cr>", "Gitsigns select hunk")
      end,
    },
  },

  -- harpoon {{{2
  {
    "theprimeagen/harpoon",
    -- stylua: ignore
    keys = {
      { "<leader>ha", function() require("harpoon.mark").add_file() end, desc = "Harpoon add" },
      { "<leader>hm", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
      { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "which_key_ignore" },
      { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "which_key_ignore" },
      { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "which_key_ignore" },
      { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "which_key_ignore" },
      { "<leader>5", function() require("harpoon.ui").nav_file(5) end, desc = "which_key_ignore" },
      { "<leader>6", function() require("harpoon.ui").nav_file(6) end, desc = "which_key_ignore" },
      { "<leader>7", function() require("harpoon.ui").nav_file(7) end, desc = "which_key_ignore" },
      { "<leader>8", function() require("harpoon.ui").nav_file(8) end, desc = "which_key_ignore" },
      { "<leader>9", function() require("harpoon.ui").nav_file(9) end, desc = "which_key_ignore" },
    },
  },

  -- headlines {{{2
  {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "norg", "org", "rmd" },
    opts = function()
      local opts = {}
      for _, ft in ipairs({ "markdown", "norg", "org", "rmd" }) do
        opts[ft] = {
          bullets = {},
          headline_highlights = {},
          fat_headline_lower_string = "▔",
        }
        for i = 1, 6 do
          local hl = "Headline" .. i
          vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
          table.insert(opts[ft].headline_highlights, hl)
        end
      end
      return opts
    end,
    config = function(_, opts)
      vim.schedule(function()
        require("headlines").setup(opts)
        require("headlines").refresh()
      end)
    end,
  },

  -- illuminate {{{2
  {
    "rrethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "]]", desc = "Next reference" },
      { "[[", desc = "Prev reference" },
    },
    opts = {
      filetypes_denylist = { "checkhealth", "fugitive" },
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end
      map("]]", "next")
      map("[[", "prev")
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
  },

  -- inc-rename {{{2
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
  },

  -- lspconfig {{{2
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "b0o/schemastore.nvim", version = false },
      { "folke/neodev.nvim", opts = {} },
    },
    opts = {
      autoformat = true,
      capabilities = {},
      diagnostics = {
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
          },
        },
        underline = true,
        update_in_insert = false,
        virtual_text = {
          prefix = "icons",
          source = "if_many",
        },
      },
      servers = {
        astro = {},
        bashls = {},
        eslint = {
          settings = {
            workingDirectories = {
              mode = "auto",
            },
          },
        },
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = {
                enable = true,
              },
            },
          },
        },
        lua_ls = {
          enabled = false,
          settings = {
            Lua = {
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        pyright = {},
        ruff_lsp = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    diagnostics = {},
                    only = { "source.organizeImports" },
                  },
                })
              end,
              desc = "Organize imports",
            },
          },
        },
        tailwindcss = {
          filetypes_exclude = { "markdown" },
          filetypes_include = {},
        },
        texlab = {
          keys = {
            { "<leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex docs", silent = true },
          },
        },
        tsserver = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    diagnostics = {},
                    only = { "source.organizeImports.ts" },
                  },
                })
              end,
              desc = "Organize imports",
            },
            {
              "<leader>cR",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    diagnostics = {},
                    only = { "source.removeUnused.ts" },
                  },
                })
              end,
              desc = "Remove unused imports",
            },
          },
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
            vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
          end,
          settings = {
            redhat = {
              telemetry = {
                enabled = false,
              },
            },
            yaml = {
              format = {
                enable = true,
              },
              keyOrdering = false,
              schemaStore = {
                enable = false,
                url = "",
              },
              validate = true,
            },
          },
        },
      },
      setup = {
        eslint = function()
          vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(event)
              local client = vim.lsp.get_clients({ bufnr = event.buf, name = "eslint" })[1]
              if client then
                local diag = vim.diagnostic.get(event.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then
                  vim.cmd("EslintFixAll")
                end
              end
            end,
          })
        end,
        ruff_lsp = function()
          on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
        tailwindcss = function(_, opts)
          local tw = require("lspconfig.server_configurations.tailwindcss")
          opts.filetypes = opts.filetypes or {}
          vim.list_extend(opts.filetypes, tw.default_config.filetypes)
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
        yamlls = function()
          on_attach(function(client, _)
            if client.name == "yamlls" then
              client.server_capabilities.documentFormattingProvider = true
            end
          end)
        end,
      },
    },
    config = function(_, opts)
      local autoformat = opts.autoformat

      local function toggle()
        if vim.b.autoformat == false then
          vim.b.autoformat = nil
          autoformat = true
        else
          autoformat = not autoformat
        end
        if autoformat then
          Util.info("Enabled format on save", { title = "Format" })
        else
          Util.warn("Disabled format on save", { title = "Format" })
        end
      end
      vim.keymap.set("n", "<leader>uf", toggle, { desc = "Toggle format on save" })

      local function format(opts)
        local buf = vim.api.nvim_get_current_buf()
        if vim.b.autoformat == false and not (opts and opts.force) then
          return
        end
        local ft = vim.bo[buf].filetype
        local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

        vim.lsp.buf.format({
          bufnr = buf,
          filter = function(client)
            if have_nls then
              return client.name == "null-ls"
            end
            return client.name ~= "null-ls"
          end,
        })
      end

      on_attach(function(client, buf)
        if
          client.config
          and client.config.capabilities
          and client.config.capabilities.documentFormattingProvider == false
        then
          return
        end

        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
            buffer = buf,
            callback = function()
              if autoformat then
                format()
              end
            end,
          })
        end
      end)

      local function diagnostic_goto(next, severity)
        local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
        severity = severity and vim.diagnostic.severity[severity] or nil
        return function()
          go({ severity = severity })
        end
      end

      local function get()
        local format = function()
          format({ force = true })
        end
        local _keys = {
          { "gd", ":Telescope lsp_definitions<cr>", desc = "Goto definition", has = "definition" },
          { "gr", ":Telescope lsp_references<cr>", desc = "References" },
          { "gD", vim.lsp.buf.declaration, desc = "Goto declaration" },
          { "gI", ":Telescope lsp_implementations<cr>", desc = "Goto implementation" },
          { "gy", ":Telescope lsp_type_definitions<cr>", desc = "Goto t[y]pe definition" },
          { "K", vim.lsp.buf.hover, desc = "Hover" },
          { "gK", vim.lsp.buf.signature_help, desc = "Signature help", has = "signatureHelp" },
          { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature help", has = "signatureHelp" },
          { "]d", diagnostic_goto(true), desc = "Next diagnostic" },
          { "[d", diagnostic_goto(false), desc = "Prev diagnostic" },
          { "]e", diagnostic_goto(true, "ERROR"), desc = "Next error" },
          { "[e", diagnostic_goto(false, "ERROR"), desc = "Prev error" },
          { "]w", diagnostic_goto(true, "WARN"), desc = "Next warning" },
          { "[w", diagnostic_goto(false, "WARN"), desc = "Prev warning" },
          { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" }, has = "codeAction" },
          { "<leader>cc", vim.lsp.codelens.run, desc = "Run codelens", mode = { "n", "v" }, has = "codeLens" },
          { "<leader>cd", vim.diagnostic.open_float, desc = "Line diagnostics" },
          { "<leader>cf", format, desc = "Format document", has = "documentFormatting" },
          { "<leader>cf", format, desc = "Format range", mode = "v", has = "documentRangeFormatting" },
          { "<leader>cl", ":LspInfo<cr>", desc = "Lsp info" },
          {
            "<leader>cr",
            function()
              local inc_rename = require("inc_rename")
              return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
            end,
            expr = true,
            desc = "Rename",
            has = "rename",
          },
          {
            "<leader>cA",
            function()
              vim.lsp.buf.code_action({
                context = {
                  only = {
                    "source",
                  },
                  diagnostics = {},
                },
              })
            end,
            desc = "Source action",
            has = "codeAction",
          },
          {
            "<leader>cC",
            vim.lsp.codelens.refresh,
            desc = "Refresh & display codelens",
            mode = { "n" },
            has = "codeLens",
          },
        }
        return _keys
      end

      on_attach(function(client, buffer)
        local Keys = require("lazy.core.handler.keys")
        local keymaps = {}

        for _, value in ipairs(get()) do
          local keys = Keys.parse(value)
          if keys[2] == vim.NIL or keys[2] == false then
            keymaps[keys.id] = nil
          else
            keymaps[keys.id] = keys
          end
        end

        for _, keys in pairs(keymaps) do
          if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
            local opts = Keys.opts(keys)
            opts.has = nil
            opts.silent = opts.silent ~= false
            opts.buffer = buffer
            vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
          end
        end
      end)

      for name, icon in pairs(icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
      if inlay_hint then
        on_attach(function(client, buffer)
          if client.supports_method("textDocument/inlayHint") then
            inlay_hint.enable(buffer, true)
          end
        end)
      end

      if vim.lsp.codelens then
        on_attach(function(client, buffer)
          if client.supports_method("textDocument/codeLens") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = buffer,
              callback = vim.lsp.codelens.refresh,
            })
          end
        end)
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
          or function(diagnostic)
            for d, icon in pairs(icons.diagnostics) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end

        require("lspconfig")[server].setup(server_opts)
      end

      require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers), handlers = { setup } })
    end,
  },

  -- lualine {{{2
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local colors = {
        [""] = fg("Special"),
        ["Normal"] = fg("Special"),
        ["Warning"] = fg("DiagnosticError"),
        ["InProgress"] = fg("DiagnosticWarn"),
      }
      return {
        extensions = { "fugitive", "neo-tree" },
        options = {
          globalstatus = true,
          theme = "auto",
          component_separators = "",
          section_separators = "",
          disabled_filetypes = {
            statusline = { "alpha", "checkhealth", "dashboard", "lazy", "mason", "TelescopePrompt" },
          },
        },
        sections = {
          lualine_a = {
            -- stylua: ignore
            { "mode", fmt = function(str) return str:sub(1, 1) end },
          },
          lualine_b = {
            -- stylua: ignore
            { "branch", icon = icons.git.branch, padding = { left = 1, right = 0 } },
          },
          lualine_c = {
            { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { readonly = "", unnamed = "" } },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
            -- stylua: ignore
            -- {
            --   function() return require("nvim-navic").get_location() end,
            --   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            -- },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            },
            -- stylua: ignore
            { "overseer", label = "", colored = true, unique = false, name = nil, name_not = false, status = nil, status_not = false },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("StatusLine") },
            {
              function()
                local status = require("copilot.api").status.data
                return icons.kinds.Copilot .. (status.message or "")
              end,
              cond = function()
                local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
                return ok and #clients > 0
              end,
              color = function()
                local status = require("copilot.api").status.data
                return colors[status.status] or colors[""]
              end,
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                hint = icons.diagnostics.Hint,
                info = icons.diagnostics.Info,
                warn = icons.diagnostics.Warn,
              },
            },
          },
          lualine_y = {
            { "progress", padding = { left = 1, right = 0 }, separator = " " },
            { "location", padding = { left = 0, right = 0 } },
          },
          lualine_z = {
            -- stylua: ignore
            { function() return icons.kinds.Keyword end, color = { fg = "Normal", bg = "NONE" } },
          },
        },
      }
    end,
  },

  -- luasnip {{{2
  {
    "l3mon4d3/luasnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<S-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
    opts = {
      delete_check_events = "TextChanged",
      history = true,
    },
  },

  -- mason {{{2
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", ":Mason<cr>", desc = "Mason" },
    },
    opts = {
      ensure_installed = {
        "black",
        "prettierd",
        "shfmt",
        "stylua",
      },
      ui = {
        icons = {
          package_installed = icons.mason.installed,
          package_pending = icons.mason.pending,
          package_uninstalled = icons.mason.uninstalled,
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- matchup {{{2
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_enabled = 0
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },

  -- mini {{{2
  -- mini.ai {{{3
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" },
          -- stylua: ignore
          e = { { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" }, "^().*()$" },
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      local i = {
        [" "] = "Whitespace",
        ['"'] = 'Balanced "',
        ["'"] = "Balanced '",
        ["`"] = "Balanced `",
        ["("] = "Balanced (",
        [")"] = "Balanced ) including white-space",
        [">"] = "Balanced > including white-space",
        ["<lt>"] = "Balanced <",
        ["]"] = "Balanced ] including white-space",
        ["["] = "Balanced [",
        ["}"] = "Balanced } including white-space",
        ["{"] = "Balanced {",
        ["?"] = "User Prompt",
        _ = "Underscore",
        a = "Argument",
        b = "Balanced ), ], }",
        c = "Class",
        d = "Digit(s)",
        e = "Word in CamelCase & snake_case",
        f = "Function",
        g = "Entire file",
        o = "Block, conditional, loop",
        q = "Quote `, \", '",
        t = "Tag",
        u = "Use/call function & method",
        U = "Use/call without dot in name",
      }
      local a = vim.deepcopy(i)
      for k, v in pairs(a) do
        a[k] = v:gsub(" including.*", "")
      end
      local ic = vim.deepcopy(i)
      local ac = vim.deepcopy(a)
      for key, name in pairs({ n = "Next", l = "Last" }) do
        i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
        a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
      end
      require("which-key").register({
        mode = { "o", "x" },
        i = i,
        a = a,
      })
    end,
  },

  -- mini.align {{{3
  {
    "echasnovski/mini.align",
    keys = {
      { "ga", desc = "Align", mode = { "n", "x" } },
      { "gA", desc = "Align with preview", mode = { "n", "x" } },
    },
    opts = {},
  },

  -- mini.bracketed {{{3
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    opts = {
      file = { suffix = "" },
      quickfix = { suffix = "" },
      treesitter = { suffix = "n" },
      window = { suffix = "" },
    },
  },

  -- mini.bufremove {{{3
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete buffer (force)" },
    },
  },

  -- mini.comment {{{3
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring({}) or vim.bo.commentstring
        end,
      },
    },
  },

  -- mini.files {{{3
  {
    "echasnovski/mini.files",
    keys = {
      {
        "<leader>fm",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open mini.files (file)",
      },
      {
        "<leader>fM",
        function()
          require("mini.files").open(vim.loop.cwd(), true)
        end,
        desc = "Open mini.files (cwd)",
      },
    },
    opts = {
      options = {
        use_as_default_explorer = false,
      },
      windows = {
        preview = true,
        width_focus = 20,
        width_preview = 80,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)
      local show_dotfiles = true
      local filter_show = function()
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end
      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh({ content = { filter = new_filter } })
      end
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden files" })
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          on_rename(event.data.from, event.data.to)
        end,
      })
    end,
  },

  -- mini.indentscope {{{3
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        -- stylua: ignore
        pattern = { "alpha", "checkhealth", "dashboard", "help", "lazy", "mason", "neo-tree", "noice", "notify", "Trouble" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    opts = function()
      return {
        draw = {
          animation = require("mini.indentscope").gen_animation.none(),
          delay = 0,
        },
        options = { try_as_border = true },
        symbol = "│",
      }
    end,
  },

  -- mini.move {{{3
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    opts = {},
  },

  -- mini.pairs {{{3
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    keys = {
      {
        "<leader>up",
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            Util.warn("Disabled auto pairs", { title = "Option" })
          else
            Util.info("Enabled auto pairs", { title = "Option" })
          end
        end,
        desc = "Toggle auto pairs",
      },
    },
    opts = {},
  },

  -- mini.splitjoin {{{3
  {
    "echasnovski/mini.splitjoin",
    event = "VeryLazy",
    opts = {},
  },

  -- mini.surround {{{3
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "x" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- navic {{{2
  {
    "smiteshp/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      on_attach(function(client, buffer)
        if client.supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = {
      depth_limit = 5,
      highlight = true,
      icons = icons.kinds,
      lazy_update_context = true,
      separator = " ",
    },
  },

  -- navigator {{{2
  {
    "numtostr/navigator.nvim",
    keys = {
      { "<C-h>", ":NavigatorLeft<cr>", silent = true, desc = "Go to left window", mode = { "n", "t" } },
      { "<C-j>", ":NavigatorDown<cr>", silent = true, desc = "Go to lower window", mode = { "n", "t" } },
      { "<C-k>", ":NavigatorUp<cr>", silent = true, desc = "Go to upper window", mode = { "n", "t" } },
      { "<C-l>", ":NavigatorRight<cr>", silent = true, desc = "Go to right window", mode = { "n", "t" } },
      { "<C-\\>", ":NavigatorPrevious<cr>", silent = true, desc = "Go to previous window", mode = { "n", "t" } },
    },
    opts = {},
  },

  -- neo-tree {{{2
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "muniftanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer explorer",
      },
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = get_root() })
        end,
        desc = "Explorer Neotree (root)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer Neotree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer (root)", remap = true },
      -- { "<leader>E", "<leader>fE", desc = "Explorer (cwd)", remap = true },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
    },
    deactivate = function()
      vim.cmd("Neotree close")
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      default_component_configs = {
        indent = {
          with_expanders = false,
        },
      },
      filesystem = {
        bind_to_cwd = false,
        filtered_items = {
          hide_dotfiles = false,
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      sources = { "buffers", "document_symbols", "filesystem", "git_status" },
      window = {
        mappings = {
          ["<space>"] = "none",
          ["O"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_parent_id()
              vim.fn.jobstart({ "open", path })
            end,
            desc = "open_with_system",
          },
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "copy_path_to_clipboard",
          },
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        on_rename(data.source, data.destination)
      end
      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },

  -- neorg {{{2
  {
    "nvim-neorg/neorg",
    cmd = "Neorg",
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.dirman"] = {
          config = {
            workspaces = {
              notes = "~/Dropbox/Documents/Neorg",
            },
          },
        },
      },
    },
  },

  -- neotest {{{2
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "antoinemadec/fixcursorhold.nvim",
    },
    -- stylua: ignore
    keys = {
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run last" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run nearest" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file" },
      { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run all test files" },
    },
    opts = {
      adapters = {},
      consumers = {
        overseer = function()
          require("neotest.consumers.overseer")
        end,
      },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          require("trouble").open({ mode = "quickfix", focus = false })
        end,
      },
      status = { virtual_text = true },
    },
    config = function(_, opts)
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          end,
        },
      }, vim.api.nvim_create_namespace("neotest"))
      opts.consumers = opts.consumers or {}
      opts.consumers.trouble = function(client)
        client.listeners.results = function(adapter_id, results, partial)
          if partial then
            return
          end
          local tree = assert(client:get_position(nil, { adapter = adapter_id }))
          local failed = 0
          for pos_id, result in pairs(results) do
            if result.status == "failed" and tree:get_key(pos_id) then
              failed = failed + 1
            end
          end
          vim.schedule(function()
            local trouble = require("trouble")
            if trouble.is_open() then
              trouble.refresh()
              if failed == 0 then
                trouble.close()
              end
            end
          end)
          return {}
        end
      end
      local adapters = {}
      for name, config in pairs(opts.adapters or {}) do
        if type(name) == "number" then
          if type(config) == "string" then
            config = require(config)
          end
          adapters[#adapters + 1] = config
        elseif config ~= false then
          local adapter = require(name)
          if type(config) == "table" and not vim.tbl_isempty(config) then
            local meta = getmetatable(adapter)
            if adapter.setup then
              adapter.setup(config)
            elseif meta and meta.__call then
              adapter(config)
            else
              error("Adapter " .. name .. " does not support setup")
            end
          end
          adapters[#adapters + 1] = adapter
        end
      end
      opts.adapters = adapters
      require("neotest").setup(opts)
    end,
  },

  -- nerd-fonts {{{2
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = {},
    },
  },

  -- nerdy {{{2
  {
    "2kabhishek/nerdy.nvim",
    keys = {
      { "<leader>fi", ":Nerdy<cr>", desc = "Find icons" },
    },
  },

  -- noice {{{2
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice all" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss all" },
      { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice history" },
      { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice last message" },
      { "<S-enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect cmdline" },
      { "<C-f>", function() if not require("noice.lsp").scroll(4) then return "<C-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = { "i", "n", "s" } },
      { "<C-b>", function() if not require("noice.lsp").scroll(-4) then return "<C-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = { "i", "n", "s" } },
    },
    opts = {
      cmdline = { view = "cmdline" },
      messages = { view = "notify" },
      lsp = {
        override = {
          ["cmp.entry.get_documentation"] = true,
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = false,
        inc_rename = true,
        long_message_to_split = true,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "msg_show",
            find = "search hit",
          },
          skip = true,
        },
        {
          filter = {
            event = "notify",
            find = "Done!",
          },
          skip = true,
        },
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          skip = true,
        },
      },
      status = {
        lsp_progress = { event = "lsp", kind = "progress" },
      },
      views = {
        mini = {
          win_options = {
            winblend = 0,
          },
        },
      },
    },
  },

  -- none-ls {{{2
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.black,
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
        },
      }
    end,
  },

  -- notify {{{2
  {
    "rcarriga/nvim-notify",
    -- stylua: ignore
    keys = {
      { "<leader>sn", function() require("telescope").extensions.notify.notify() end, desc = "Notifications" },
      { "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss all notifications" },
    },
    opts = function()
      local stages = require("notify.stages.static")("top_down")
      return {
        icons = {
          DEBUG = "",
          ERROR = icons.diagnostics.Error,
          INFO = icons.diagnostics.Info,
          TRACE = icons.diagnostics.Hint,
          WARN = icons.diagnostics.Warn,
        },
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
        render = "compact",
        stages = {
          function(...)
            local opts = stages[1](...)
            if opts then
              opts.border = "none"
            end
            return opts
          end,
          unpack(stages, 2),
        },
        timeout = 3000,
      }
    end,
  },

  -- numb {{{2
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    opts = {
      show_numbers = false,
    },
  },

  -- obsidian {{{2
  {
    "epwalsh/obsidian.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>on", ":ObsidianNew<cr>", desc = "Obsidian new" },
      { "<leader>os", ":ObsidianQuickSwitch<cr>", desc = "Obsidian switch" },
    },
    opts = {
      workspaces = {
        {
          name = "Obsidian",
          path = "~/Dropbox/Documents/Obsidian",
        },
      },
    },
  },

  -- octo {{{2
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {},
  },

  -- oil {{{2
  {
    "stevearc/oil.nvim",
    keys = {
      { "-", ":Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      float = {
        win_options = {
          winblend = 0,
        },
      },
      keymaps = {
        ["q"] = "actions.close",
      },
    },
  },

  -- outline {{{2
  {
    "hedyhli/outline.nvim",
    keys = {
      { "<leader>cs", ":Outline<cr>", desc = "Symbols outline" },
    },
    opts = function()
      local defaults = require("outline.config").defaults
      local opts = { symbols = {}, symbol_blacklist = {} }
      for kind, symbol in pairs(defaults.symbols) do
        opts.symbols[kind] = {
          icon = icons.kinds[kind] or symbol.icon,
          hl = symbol.hl,
        }
        if not vim.tbl_contains(symbols, kind) then
          table.insert(opts.symbol_blacklist, kind)
        end
      end
      return opts
    end,
  },

  -- overseer {{{2
  {
    "stevearc/overseer.nvim",
    keys = {
      { "<leader>ob", ":OverseerBuild<cr>", desc = "Build" },
      { "<leader>oc", ":OverseerClearCache<cr>", desc = "Clear cache" },
      { "<leader>oi", ":OverseerInfo<cr>", desc = "Info" },
      { "<leader>oq", ":OverseerQuickAction<cr>", desc = "Quick action" },
      { "<leader>or", ":OverseerRun<cr>", desc = "Run" },
      { "<leader>ot", ":OverseerToggle<cr>", desc = "Toggle" },
      { "<leader>ow", ":WatchRun<cr>", desc = "Watch" },
    },
    opts = {
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_dispose",
        },
      },
      confirm = {
        win_opts = {
          winblend = 0,
        },
      },
      dap = false,
      form = {
        win_opts = {
          winblend = 0,
        },
      },
      strategy = {
        "toggleterm",
        direction = "vertical",
        open_on_start = false,
      },
      task_list = {
        bindings = {
          ["<C-h>"] = false,
          ["<C-j>"] = false,
          ["<C-k>"] = false,
          ["<C-l>"] = false,
        },
      },
      task_win = {
        win_opts = {
          winblend = 0,
        },
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
      overseer.register_template({
        name = "run script",
        builder = function()
          local file = vim.fn.expand("%:p")
          local cmd = { file }
          if vim.bo.filetype == "javascript" then
            cmd = { "node", file }
          end
          return {
            cmd = cmd,
            components = {
              { "on_output_quickfix", set_diagnostics = true },
              "on_result_diagnostics",
              "default",
            },
          }
        end,
        condition = {
          filetype = { "javascript", "python", "sh" },
        },
      })
      vim.api.nvim_create_user_command("WatchRun", function()
        overseer.run_template({ name = "run script" }, function(task)
          if task then
            task:add_component({ "restart_on_save", paths = { vim.fn.expand("%:p") } })
            local main_win = vim.api.nvim_get_current_win()
            overseer.run_action(task, "open vsplit")
            vim.api.nvim_set_current_win(main_win)
          else
            vim.notify("WatchRun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
          end
        end)
      end, {})
    end,
  },

  -- peek {{{2
  {
    "toppair/peek.nvim",
    enabled = false,
    build = "deno task --quiet build:fast",
    -- stylua: ignore
    keys = {
      { "<leader>cp", function() local peek = require("peek") if peek.is_open() then peek.close() else peek.open() end end, desc = "Peek (markdown preview)" }
    },
    opts = {
      app = "Google Chrome",
    },
  },

  -- persistence {{{2
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    -- stylua: ignore
    keys = {
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
    },
    opts = {
      options = vim.opt.sessionoptions:get(),
    },
  },

  -- presence {{{2
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    opts = {
      neovim_image_text = "Neovim",
    },
  },

  -- rainbow {{{2
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    opts = {
      highlight = {
        "TSRainbowBlue",
        "TSRainbowRed",
        "TSRainbowCyan",
        "TSRainbowGreen",
        "TSRainbowViolet",
        "TSRainbowOrange",
        "TSRainbowYellow",
      },
    },
    config = function(_, opts)
      require("rainbow-delimiters.setup").setup(opts)
    end,
  },

  -- refactoring {{{2
  {
    "theprimeagen/refactoring.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>rr", function() require("refactoring").select_refactor({}) end, silent = true, desc = "Refactor", mode = "v" },
    },
  },

  -- repeat {{{2
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },

  -- replace {{{2
  {
    "roobert/search-replace.nvim",
    keys = {
      { "<leader>re", ":SearchReplaceSingleBufferCExpr<cr>", desc = "CExpr" },
      { "<leader>rf", ":SearchReplaceSingleBufferCFile<cr>", desc = "CFile" },
      { "<leader>ro", ":SearchReplaceSingleBufferOpen<cr>", desc = "Open" },
      { "<leader>rs", ":SearchReplaceSingleBufferSelections<cr>", desc = "Selections" },
      { "<leader>rw", ":SearchReplaceSingleBufferCWord<cr>", desc = "CWord" },
      { "<leader>rW", ":SearchReplaceSingleBufferCWORD<cr>", desc = "CWORD" },
    },
    opts = {
      default_replace_single_buffer_options = "gI",
    },
  },

  -- rsi {{{2
  {
    "tpope/vim-rsi",
    event = "VeryLazy",
  },

  -- spectre {{{2
  {
    "nvim-pack/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (spectre)" },
    },
  },

  -- startuptime {{{2
  {
    "dstein64/vim-startuptime",
    keys = {
      { "<leader>sU", ":vertical StartupTime<cr>", desc = "StartupTime" },
    },
  },

  -- styler {{{2
  {
    "folke/styler.nvim",
    event = "VeryLazy",
    dependencies = { "tokyonight.nvim" },
    opts = {
      themes = {
        help = { colorscheme = "tokyonight" },
        lazy = { colorscheme = "tokyonight" },
      },
    },
  },

  -- substitute {{{2
  {
    "gbprod/substitute.nvim",
    -- stylua: ignore
    keys = {
      { "cx", function() require("substitute.exchange").operator() end, desc = "Exchange operator" },
      { "cxc", function() require("substitute.exchange").cancel() end, desc = "Exchange cancel" },
      { "cxx", function() require("substitute.exchange").line() end, desc = "Exchange line" },
      { "X", function() require("substitute.exchange").visual() end, desc = "Exchange visual", mode = "x" },
    },
    opts = function()
      return {
        highlight_substituted_text = {
          enabled = false,
          timer = 150,
        },
        on_substitute = require("yanky.integration").substitute(),
      }
    end,
  },

  -- telescope {{{2
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        keys = {
          { "<leader><cr>", ":Telescope frecency<cr>", desc = "Frecency files" },
        },
        config = function()
          require("telescope").load_extension("frecency")
        end,
      },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        keys = {
          { "<leader>fB", ":Telescope file_browser<cr>", desc = "Browser" },
        },
        config = function()
          require("telescope").load_extension("file_browser")
        end,
      },
      {
        "ahmedkhalf/project.nvim",
        keys = {
          { "<leader>fp", ":Telescope projects<cr>", desc = "Find projects" },
        },
        config = function()
          require("project_nvim").setup()
          require("telescope").load_extension("projects")
        end,
      },
      {
        "debugloop/telescope-undo.nvim",
        keys = {
          { "<leader>su", ":Telescope undo<cr>", desc = "Undo" },
        },
        config = function()
          require("telescope").load_extension("undo")
        end,
      },
    },
    cmd = "Telescope",
    keys = {
      { "<leader><space>", ":Telescope fd<cr>", desc = "Find files (root)" },
      { "<leader>,", ":Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch buffer" },
      { "<leader>:", ":Telescope command_history<cr>", desc = "Command history" },
      { "<leader>;", telescope("live_grep"), desc = "Grep (root)" },
      { "<leader>'", ":Telescope marks<cr>", desc = "Jump to mark" },
      { '<leader>"', ":Telescope registers<cr>", desc = "Registers" },
      { "<leader>/", ":Telescope search_history<cr>", desc = "Search history" },
      { "<leader>fb", ":Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>fc", telescope("files", { cwd = vim.fn.stdpath("config") }), desc = "Find config" },
      { "<leader>fC", telescope("files", { cwd = vim.env.XDG_CONFIG_HOME }), desc = "Find config files" },
      { "<leader>ff", telescope("files"), desc = "Find files (root)" },
      { "<leader>fF", telescope("files", { cwd = false }), desc = "Find files (cwd)" },
      { "<leader>fg", ":Telescope git_files<cr>", desc = "Find files (git)" },
      { "<leader>fr", ":Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>fR", telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
      { "<leader>sa", ":Telescope autocommands<cr>", desc = "Auto commands" },
      { "<leader>sb", ":Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sc", ":Telescope command_history<cr>", desc = "Command history" },
      { "<leader>sC", ":Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", ":Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>sD", ":Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>sg", telescope("live_grep"), desc = "Grep (root)" },
      { "<leader>sG", telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
      { "<leader>sh", ":Telescope help_tags<cr>", desc = "Help pages" },
      { "<leader>sH", ":Telescope highlights<cr>", desc = "Highlight groups" },
      { "<leader>sk", ":Telescope keymaps<cr>", desc = "Key maps" },
      { "<leader>sm", ":Telescope marks<cr>", desc = "Jump to mark" },
      { "<leader>sM", ":Telescope man_pages<cr>", desc = "Man pages" },
      { "<leader>so", ":Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", ":Telescope resume<cr>", desc = "Resume" },
      { "<leader>ss", telescope("lsp_document_symbols", { symbols = symbols }), desc = "Goto symbol" },
      { "<leader>sS", telescope("lsp_dynamic_workspace_symbols", { symbols = symbols }), desc = "Goto symbol (work)" },
      { "<leader>sw", telescope("grep_string", { word_match = "-w" }), desc = "Word (root)" },
      { "<leader>sW", telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
      { "<leader>sw", telescope("grep_string"), mode = "v", desc = "Selection (root)" },
      { "<leader>sW", telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
      { "<leader>uC", telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find plugin file",
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end
      local find_files_no_ignore = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        telescope("find_files", { no_ignore = true, default_text = line })()
      end
      local find_files_with_hidden = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        telescope("find_files", { hidden = true, default_text = line })()
      end
      local function flash(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end
      return {
        defaults = {
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<C-t>"] = open_with_trouble,
              ["<A-t>"] = open_selected_with_trouble,
              ["<A-i>"] = find_files_no_ignore,
              ["<A-h>"] = find_files_with_hidden,
              ["<C-down>"] = actions.cycle_history_next,
              ["<C-up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<esc>"] = actions.close,
              ["<C-s>"] = flash,
            },
            n = {
              ["q"] = actions.close,
              ["s"] = flash,
            },
          },
          prompt_prefix = icons.telescope.prompt,
          selection_caret = icons.telescope.selection,
        },
        pickers = {
          fd = {
            find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
          },
        },
      }
    end,
  },

  -- todo-comments {{{2
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>st", ":TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", ":TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
      { "<leader>xt", ":TodoTrouble<cr>", desc = "Todo (trouble)" },
      { "<leader>xT", ":TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (trouble)" },
    },
    opts = {},
  },

  -- toggleterm {{{2
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<leader>tf", ":ToggleTerm direction=float<cr>", desc = "ToggleTerm float" },
      { "<leader>th", ":ToggleTerm direction=horizontal<cr>", desc = "ToggleTerm horizontal" },
      { "<leader>tv", ":ToggleTerm direction=vertical<cr>", desc = "ToggleTerm vertical" },
    },
    opts = {
      open_mapping = [[<C-\>]],
      size = function(term)
        if term.direction == "horizontal" then
          return 12
        elseif term.direction == "vertical" then
          return 60
        end
      end,
    },
  },

  -- treesitter {{{2
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
      {
        "joosepalviste/nvim-ts-context-commentstring",
        opts = {
          enable_autocmd = false,
        },
      },
      {
        "ckolkey/ts-node-action",
        -- stylua: ignore
        keys = {
          { "<C-g>", function() require("ts-node-action").node_action() end, desc = "Trigger node action" },
        },
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          local move = require("nvim-treesitter.textobjects.move")
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name]
                  for key, query in pairs(config or {}) do
                    if q == query and key:find("[%]%[][cC]") then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
      -- { "nvim-treesitter/nvim-treesitter-context", event = "BufReadPre" },
      -- { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
    },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<C-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    opts = {
      autotag = { enable = true },
      ensure_installed = {
        "astro",
        "bash",
        "css",
        "diff",
        "html",
        "javascript",
        "json",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = {
        enable = true,
        disable = { "latex" },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_decremental = "<bs>",
          node_incremental = "v",
          scope_incremental = false,
        },
      },
      indent = { enable = true },
      matchup = { enable = true },
      playground = { enable = false },
      query_linter = { enable = false },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.g.skip_ts_context_commentstring_module = true
    end,
  },

  -- trouble {{{2
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xL", ":TroubleToggle loclist<cr>", desc = "Location list (trouble)" },
      { "<leader>xQ", ":TroubleToggle quickfix<cr>", desc = "Quickfix list (trouble)" },
      { "<leader>xx", ":TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics (trouble)" },
      { "<leader>xX", ":TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics (trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
    opts = {
      indent_lines = false,
      use_diagnostic_signs = true,
    },
  },

  -- undotree {{{2
  {
    "mbbill/undotree",
    keys = {
      { "<leader>uu", ":UndotreeToggle<cr>", desc = "Toggle Undotree" },
    },
  },

  -- venv {{{2
  {
    "linux-cultist/venv-selector.nvim",
    keys = {
      { "<leader>cv", ":VenvSelect<cr>", desc = "Select virtualenv" },
    },
    opts = {
      name = { "env", ".env", "venv", ".venv" },
    },
  },

  -- vimtex {{{2
  {
    "lervag/vimtex",
    lazy = true,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "bib", "tex" },
        callback = function()
          vim.wo.conceallevel = 2
        end,
      })
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
      vim.g.vimtex_view_general_viewer = "zathura"
    end,
  },

  -- wakatime {{{2
  {
    "wakatime/vim-wakatime",
    enabled = false,
    event = "VeryLazy",
  },

  -- which-key {{{2
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        mode = { "n", "v" },
        ["c"] = { name = "+change" },
        ["d"] = { name = "+delete" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["v"] = { name = "+visual" },
        ["y"] = { name = "+yank" },
        ["z"] = { name = "+fold" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>a"] = { name = "+ai" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>d"] = { name = "+debug" },
        ["<leader>f"] = { name = "+file" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>h"] = { name = "+hunk" },
        ["<leader>n"] = { name = "+noice" },
        ["<leader>o"] = { name = "+overseer" },
        ["<leader>p"] = { name = "+plugin" },
        ["<leader>q"] = { name = "+quit" },
        ["<leader>r"] = { name = "+replace" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>t"] = { name = "+test" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+window" },
        ["<leader>x"] = { name = "+quickfix" },
        ["<localleader>l"] = { name = "+vimtex" },
        ["<2-LeftMouse>"] = { "which_key_ignore" },
      },
      icons = {
        breadcrumb = icons.whichkey.breadcrumb,
        group = icons.whichkey.group,
        separator = icons.whichkey.separator,
      },
      show_help = false,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },

  -- yanky {{{2
  {
    "gbprod/yanky.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    -- stylua: ignore
    keys = {
      { "y", "<Plug>(YankyYank)", desc = "Yank text", mode = { "n", "x" } },
      { "p", "<Plug>(YankyPutAfter)", desc = "Put yanked text after cursor", mode = { "n", "x" } },
      { "P", "<Plug>(YankyPutBefore)", desc = "Put yanked text before cursor", mode = { "n", "x" } },
      { "gp", "<Plug>(YankyGPutAfter)", desc = "Put yanked text after selection", mode = { "n", "x" } },
      { "gP", "<Plug>(YankyGPutBefore)", desc = "Put yanked text before selection", mode = { "n", "x" } },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
      { "<C-n>", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "<C-p>", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
      { "<leader>sp", function() require("telescope").extensions.yank_history.yank_history() end, desc = "Open yank history" },
    },
    opts = {
      highlight = {
        on_put = false,
        timer = 150,
      },
      ring = {
        storage = "sqlite",
      },
    },
  },

  -- zen-mode {{{2
  {
    "folke/zen-mode.nvim",
    build = "gsed -i 's/+ 4/+ 5/' " .. vim.fn.stdpath("data") .. "/lazy/dashboard-nvim/lua/dashboard/theme/header.lua",
    dependencies = { "folke/twilight.nvim" },
    keys = {
      { "<leader>z", ":ZenMode<cr>", desc = "ZenMode" },
    },
  },
}

-- lazy {{{2
require("lazy").setup(plugins, {
  change_detection = {
    notify = false,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  dev = {
    path = "~/code",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    backdrop = 100,
  },
})

-- Options {{{1
local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.expandtab = true
opt.fillchars = { diff = "╱", eob = " " }
opt.foldmethod = "marker"
opt.foldtext = "v:lua.foldtext()"
opt.ignorecase = true
opt.laststatus = 0
opt.mouse = "a"
opt.ruler = false
opt.sessionoptions = { "buffers", "curdir", "folds", "globals", "help", "tabpages", "terminal", "winsize" }
opt.shiftwidth = 2
opt.shortmess:append("acCW")
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true
opt.smoothscroll = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.updatetime = 100
opt.wrap = false

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Keymaps {{{1
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  local modes = vim.split(mode, "")
  if not keys.active[keys.parse({ lhs, mode = modes }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "*", "*zzzv")
map("n", "#", "#zzzv")
map("nv", "H", "^")
map("nv", "L", "g_")
map("nv", "M", "%")
map("n", "Q", "@q")
map("n", "U", "<C-r>")
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "gg", "gg0")
map("nx", "gw", "*N", { desc = "Search word under cursor" })

map("n", "<C-q>", ":q<cr>", { desc = "Quit file" })
map("nsx", "<C-s>", ":w<cr><esc>", { desc = "Save file" })
map("n", "<bs>", ":b#<cr>", { desc = "Switch buffer" })
map("n", "<cr>", "ciw", { desc = "Change inner word" })
map("n", "<tab>", "<C-w>w", { desc = "Switch windows" })
map("n", "<S-tab>", "<C-w>W", { desc = "Switch windows" })
map("t", "<esc>", "<C-\\><C-n>", { desc = "Enter normal mode" })

map("n", "[<space>", ":<C-u>put!=repeat(nr2char(10), v:count1)<cr>'[", { desc = "Add blank lines above" })
map("n", "]<space>", ":<C-u>put =repeat(nr2char(10), v:count1)<cr>", { desc = "Add blank lines below" })

-- stylua: ignore start
map("n", "<leader>.", ":<C-p><cr>", { desc = "Repeat" })
map("n", "<leader>k", ":norm! K<cr>", { desc = "Keywordprg" })
map("n", "<leader>l", ":Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>v", ":vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>ba", ":bufdo bd<cr>", { desc = "Delete all buffer" })
map("n", "<leader>bb", ":e#<cr>", { desc = "Switch buffer" })
map("n", "<leader>bf", ":bfirst<cr>", { desc = "First buffer" })
map("n", "<leader>bl", ":blast<cr>", { desc = "Last buffer" })
map("n", "<leader>bn", ":bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bs", scratch, { desc = "Scratch buffer" })
map("n", "<leader>ch", ":checkhealth<cr>", { desc = "Checkhealth" })
map("n", "<leader>fn", ":enew<cr>", { desc = "New file" })
map("n", "<leader>ft", float_term(nil, { cwd = get_root() }), { desc = "Terminal (root)" })
map("n", "<leader>fT", float_term(), { desc = "Terminal (cwd)" })
map("n", "<leader>gg", float_term({ "lazygit" }, { cwd = get_root() }), { desc = "Lazygit (root)" })
map("n", "<leader>gG", float_term({ "lazygit" }), { desc = "Lazygit (cwd)" })
map("n", "<leader>nc", ":e $MYVIMRC<cr>", { desc = "Neovim config" })
map("n", "<leader>ne", ":h news<cr>", { desc = "Neovim news" })
map("n", "<leader>pb", ":Lazy build<cr>", { desc = "Build" })
map("n", "<leader>pc", ":Lazy check<cr>", { desc = "Check" })
map("n", "<leader>pd", ":Lazy debug<cr>", { desc = "Debug" })
map("n", "<leader>ph", ":Lazy home<cr>", { desc = "Home" })
map("n", "<leader>pi", ":Lazy install<cr>", { desc = "Install" })
map("n", "<leader>pl", ":Lazy log<cr>", { desc = "Log" })
map("n", "<leader>pp", ":Lazy profile<cr>", { desc = "Profile" })
map("n", "<leader>pr", ":Lazy restore<cr>", { desc = "Restore" })
map("n", "<leader>ps", ":Lazy sync<cr>", { desc = "Sync" })
map("n", "<leader>pu", ":Lazy update<cr>", { desc = "Update" })
map("n", "<leader>px", ":Lazy clean<cr>", { desc = "Clean" })
map("n", "<leader>qq", ":qa<cr>", { desc = "Quit all" })
map("n", "<leader>td", ":tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>tf", ":tabfirst<cr>", { desc = "First tab" })
map("n", "<leader>tl", ":tablast<cr>", { desc = "Last tab" })
map("n", "<leader>tn", ":tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>tp", ":tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader>ud", toggle_diagnostics, { desc = "Toggle diagnostics" })
map("n", "<leader>uh", function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle inlay hints" })
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect position" })
map("n", "<leader>ul", function() toggle("list") end, { desc = "Toggle list" })
map("n", "<leader>ur", function() toggle("relativenumber") end, { desc = "Toggle relative numbers" })
map("n", "<leader>us", function() toggle("spell") end, { desc = "Toggle spelling" })
map("n", "<leader>uw", function() toggle("wrap") end, { desc = "Toggle word wrap" })
map("n", "<leader>ux", ":noh<bar>diffupdate<bar>normal! <C-l><cr>", { desc = "Redraw/Clear/Update" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })
map("n", "<leader>ww", "<C-w>p", { desc = "Other window" })
map("n", "<leader>xl", ":lopen<cr>", { desc = "Location list" })
map("n", "<leader>xq", ":copen<cr>", { desc = "Quickfix list" })
-- stylua: ignore end

vim.cmd([[cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<down>"]])
vim.cmd([[cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<up>"]])

-- Autocmds {{{1
local autocmd = vim.api.nvim_create_autocmd
local namespace = vim.api.nvim_create_namespace

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("VimResized", {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

autocmd("BufReadPost", {
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("FileType", {
  pattern = { "help", "man" },
  command = "wincmd T",
})

autocmd("FileType", {
  pattern = { "checkhealth", "fugitive", "help", "man", "qf", "spectre_panel", "startuptime" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", ":close<cr>", { buffer = event.buf, silent = true })
  end,
})

autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})

local url_matcher =
  "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

autocmd("FileType", {
  pattern = "*",
  callback = function()
    for _, match in ipairs(vim.fn.getmatches()) do
      if match.group == "HighlightURL" then
        vim.fn.matchdelete(match.id)
      end
    end
    vim.fn.matchadd("HighlightURL", url_matcher, 15)
  end,
})

autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local pos = vim.fn.winsaveview()
    vim.cmd("keeppatterns %s/\\s\\+$//e")
    vim.fn.winrestview(pos)
  end,
})

autocmd("BufWritePre", {
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.filetype.add({
  filename = {
    [".env"] = "config",
  },
  pattern = {
    ["req.*.txt"] = "config",
  },
})

vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    local keys = { "<cr>", "n", "N", "v", "*", "#", "?", "/" }
    local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
  if vim.fn.mode() == "v" then
    vim.opt.hlsearch = false
  end
end, namespace("toggle_hlsearch"))
-- }}}
