local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazynvim = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", lazynvim, lazypath })
end
vim.opt.rtp:prepend(lazypath)

local opts = {
  colorscheme = "dracula",
  icons = {
    diagnostics = {
      Error = "󰅚 ",
      Hint = " ",
      Info = " ",
      Warn = "󰀪 ",
    },
    git = {
      added = "+",
      branch = "",
      modified = "~",
      removed = "-",
    },
  },
}

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = opts },
    { import = "plugins" },
  },
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
  install = {
    colorscheme = { "dracula", "default" },
  },
  ui = {
    backdrop = 100,
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
})
