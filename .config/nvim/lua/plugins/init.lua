return {
  -- dracula
  {
    "exshak/dracula.nvim",
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
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    opts = {
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
      end,
    },
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = { "", "" },
        show_buffer_close_icons = false,
      },
    },
  },

  -- copilotchat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      separator = " ",
      show_folds = false,
      show_help = false,
    },
  },

  -- dashboard
  {
    "nvimdev/dashboard-nvim",
    opts = function()
      return {
        config = {
          center = {
            { key = "c", icon = " ", desc = " Config", action = "lua LazyVim.pick.config_files()()" },
            { key = "f", icon = " ", desc = " Find", action = "Telescope fd" },
            { key = "g", icon = " ", desc = " Grep", action = "lua LazyVim.pick('live_grep')()" },
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
          file_height = 24,
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
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end
      require("dashboard").setup(opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        -- stylua: ignore
        callback = function(event)
          vim.keymap.set("n", "b", scratch, { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "e", ":Neotree<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "h", ":checkhealth<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "m", ":Mason<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "n", ":enew<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "o", ":ObsidianQuickSwitch<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "t", ":Lazy profile<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "u", ":Lazy update<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "v", ":e ~/.config/nvim/lua/plugins/init.lua<cr>", { buffer = event.buf, nowait = true, silent = true })
          vim.keymap.set("n", "x", ":LazyExtras<cr>", { buffer = event.buf, nowait = true, silent = true })
        end,
      })
    end,
  },

  -- fugitive
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    keys = {
      { "<leader>ga", ":Gwrite<cr>", desc = "Add" },
      { "<leader>gd", ":Gvdiffsplit<cr>", desc = "Diff" },
      { "<leader>gh", ":GBrowse!<cr>", desc = "Hub" },
      { "<leader>gs", ":G<cr>", desc = "Status" },
    },
  },

  -- gitsigns
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        untracked = { text = " " },
      },
      signs_staged_enable = false,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          local modes = vim.split(mode, "")
          vim.keymap.set(modes, l, r, { buffer = buffer, desc = desc })
        end
        -- stylua: ignore start
        map("n", "]h", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end end, "Next Hunk")
        map("n", "[h", function() if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>hB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff This ~")
        map("n", "<leader>hp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("nv", "<leader>hr", ":Gitsigns reset_hunk<cr>", "Reset Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("nv", "<leader>hs", ":Gitsigns stage_hunk<cr>", "Stage Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("ox", "ih", ":<C-u>Gitsigns select_hunk<cr>", "GitSigns Select Hunk")
      end,
    },
  },

  -- indent
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      enabled = false,
    },
  },

  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = {
          prefix = "icons",
        },
      },
    },
  },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local colors = {
        [""] = LazyVim.ui.fg("Special"),
        ["Normal"] = LazyVim.ui.fg("Special"),
        ["Warning"] = LazyVim.ui.fg("DiagnosticError"),
        ["InProgress"] = LazyVim.ui.fg("DiagnosticWarn"),
      }
      local icons = LazyVim.config.icons
      local symbols = require("trouble").statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      return {
        extensions = { "fugitive", "neo-tree" },
        options = {
          component_separators = "",
          disabled_filetypes = {
            statusline = { "alpha", "checkhealth", "dashboard", "lazy", "lazyterm", "mason", "TelescopePrompt" },
          },
          globalstatus = true,
          section_separators = "",
          theme = "auto",
        },
        -- stylua: ignore
        sections = {
          lualine_a = {
            { "mode", fmt = function(str) return str:sub(1, 1) end },
          },
          lualine_b = {
            { "branch", icon = icons.git.branch, padding = { left = 1, right = 0 } },
          },
          lualine_c = {
            LazyVim.lualine.root_dir(),
            { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
            { LazyVim.lualine.pretty_path() },
            { "diff", symbols = { added = icons.git.added, modified = icons.git.modified, removed = icons.git.removed } },
            { symbols and symbols.get, cond = symbols and symbols.has },
          },
          lualine_x = {
            { function() return require("noice").api.status.command.get() end, cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end },
            { function() return require("noice").api.status.mode.get() end, cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end },
            { "overseer", label = "", colored = true, unique = false, name = nil, name_not = false, status = nil, status_not = false },
            { function() return "  " .. require("dap").status() end, cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = LazyVim.ui.fg("StatusLine") },
            { function() local status = require("copilot.api").status.data return icons.kinds.Copilot .. (status.message or "") end, cond = function() local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 }) return ok and #clients > 0 end, color = function() local status = require("copilot.api").status.data return colors[status.status] or colors[""] end },
            { "diagnostics", symbols = { error = icons.diagnostics.Error, hint = icons.diagnostics.Hint, info = icons.diagnostics.Info, warn = icons.diagnostics.Warn } },
          },
          lualine_y = {
            { "progress", padding = { left = 1, right = 0 }, separator = " " },
            { "location", padding = { left = 0, right = 0 } },
          },
          lualine_z = {
            { function() return icons.kinds.Keyword end, color = { fg = "Normal", bg = "NONE" } },
          },
        },
      }
    end,
  },

  -- markdown
  {
    "MeanderingProgrammer/markdown.nvim",
    ft = { "markdown", "norg", "org", "rmd" },
    opts = {
      code = {
        right_pad = 1,
        sign = false,
        width = "block",
      },
      file_types = { "markdown", "norg", "org", "rmd" },
      heading = {
        icons = {},
        sign = false,
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      LazyVim.toggle.map("<leader>um", {
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      })
    end,
  },

  -- matchup
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_enabled = 0
    end,
  },

  -- mini.align
  {
    "echasnovski/mini.align",
    keys = {
      { "ga", desc = "Align", mode = { "n", "x" } },
      { "gA", desc = "Align with Preview", mode = { "n", "x" } },
    },
    opts = {},
  },

  -- mini.pairs
  {
    "echasnovski/mini.pairs",
    opts = {
      modes = {
        command = false,
      },
    },
  },

  -- mini.splitjoin
  {
    "echasnovski/mini.splitjoin",
    event = "VeryLazy",
    opts = {},
  },

  -- navigator
  {
    "numtostr/navigator.nvim",
    keys = {
      { "<C-h>", ":NavigatorLeft<cr>", silent = true, desc = "Go to Left Window", mode = { "n", "t" } },
      { "<C-j>", ":NavigatorDown<cr>", silent = true, desc = "Go to Lower Window", mode = { "n", "t" } },
      { "<C-k>", ":NavigatorUp<cr>", silent = true, desc = "Go to Upper Window", mode = { "n", "t" } },
      { "<C-l>", ":NavigatorRight<cr>", silent = true, desc = "Go to Right Window", mode = { "n", "t" } },
      { "<C-\\>", ":NavigatorPrevious<cr>", silent = true, desc = "Go to Previous Window", mode = { "n", "t" } },
    },
    opts = {},
  },

  -- neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", "<leader>fe", desc = "Explorer (root)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer (cwd)", remap = true },
    },
    opts = {
      default_component_configs = {
        indent = {
          with_expanders = false,
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
    },
  },

  -- node-action
  {
    "ckolkey/ts-node-action",
    -- stylua: ignore
    keys = {
      { "<C-g>", function() require("ts-node-action").node_action() end, desc = "Trigger Node Action" },
    },
  },

  -- noice
  {
    "folke/noice.nvim",
    -- stylua: ignore
    keys = function()
      return {
        { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice All" },
        { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
        { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
        { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
        { "<leader>nt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
        { "<S-enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
        { "<C-f>", function() if not require("noice.lsp").scroll(4) then return "<C-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = { "i", "n", "s" } },
        { "<C-b>", function() if not require("noice.lsp").scroll(-4) then return "<C-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = { "i", "n", "s" } },
      }
    end,
    opts = {
      cmdline = { view = "cmdline" },
      presets = {
        command_palette = false,
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
      views = {
        mini = {
          win_options = {
            winblend = 0,
          },
        },
      },
    },
  },

  -- notify
  {
    "rcarriga/nvim-notify",
    -- stylua: ignore
    keys = {
      { "<leader>sn", function() require("telescope").extensions.notify.notify() end, desc = "Notifications" },
    },
    opts = {
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { border = "none", zindex = 100 })
      end,
      render = "compact",
    },
  },

  -- obsidian
  {
    "epwalsh/obsidian.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>on", ":ObsidianNew<cr>", desc = "Obsidian New" },
      { "<leader>os", ":ObsidianQuickSwitch<cr>", desc = "Obsidian Switch" },
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

  -- overseer
  {
    "stevearc/overseer.nvim",
    keys = {
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

  -- styler
  {
    "folke/styler.nvim",
    event = "VeryLazy",
    opts = {
      themes = {
        help = { colorscheme = "tokyonight" },
        lazy = { colorscheme = "tokyonight" },
      },
    },
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-frecency.nvim",
        keys = {
          { "<leader><cr>", ":Telescope frecency<cr>", desc = "Frecency Files" },
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
    },
    keys = {
      { "<leader><space>", ":Telescope fd<cr>", desc = "Find Files (root)" },
      { "<leader>;", LazyVim.pick("live_grep"), desc = "Grep (root)" },
      { "<leader>'", ":Telescope marks<cr>", desc = "Jump to Mark" },
      { '<leader>"', ":Telescope registers<cr>", desc = "Registers" },
      { "<leader>/", ":Telescope search_history<cr>", desc = "Search History" },
      { "<leader>fC", LazyVim.pick("files", { cwd = vim.env.XDG_CONFIG_HOME }), desc = "Find Config" },
      { "<leader>fP", LazyVim.pick("files", { cwd = require("lazy.core.config").options.root }), desc = "Find Plugin" },
    },
    opts = function(_, opts)
      opts.defaults.mappings.i["<esc>"] = require("telescope.actions").close
      opts.pickers = opts.pickers or {}
      opts.pickers.fd = {
        find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
      }
    end,
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      incremental_selection = {
        keymaps = {
          node_incremental = "v",
        },
      },
      matchup = { enable = true },
    },
  },

  -- vimtex
  {
    "lervag/vimtex",
    lazy = true,
  },

  -- wakatime
  {
    "wakatime/vim-wakatime",
    enabled = false,
    event = "VeryLazy",
  },

  -- which-key
  {
    "folke/which-key.nvim",
    opts = {
      show_help = false,
      spec = {
        {
          { "<leader>h", group = "hunk" },
          { "<leader>n", group = "noice" },
          { "<leader>r", group = "replace" },
        },
      },
      win = {
        no_overlap = false,
      },
    },
  },

  -- yanky
  {
    "gbprod/yanky.nvim",
    opts = {
      highlight = {
        on_put = false,
      },
    },
  },

  -- zen-mode
  {
    "folke/zen-mode.nvim",
    dependencies = { "folke/twilight.nvim" },
    keys = {
      { "<leader>z", ":ZenMode<cr>", desc = "Zen Mode" },
    },
  },
}
