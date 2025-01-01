local opt = vim.opt

opt.cursorline = false
opt.number = false
opt.pumblend = 0
opt.relativenumber = false
opt.wildmode = "full"

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.vimtex_view_general_viewer = "zathura"

function _G.scratch()
  vim.cmd("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.buflisted = false
  vim.bo.swapfile = false
end
