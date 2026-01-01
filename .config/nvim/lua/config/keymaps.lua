local function map(mode, lhs, rhs, opts)
  local modes = vim.split(mode, "")
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(modes, lhs, rhs, opts)
end

map("nox", "H", "^")
map("nox", "L", "g_")
map("nox", "M", "<plug>(matchup-%)")
map("n", "gg", "gg0")
map("nx", "gw", "*N", { desc = "Search Word" })
map("n", "<C-q>", ":q<cr>", { desc = "Quit File" })
map("n", "<bs>", ":b#<cr>", { desc = "Switch Buffer" })
map("n", "<cr>", "ciw", { desc = "Change Inner Word" })
map("n", "<tab>", "<C-w>w", { desc = "Switch Window" })
map("n", "<S-tab>", "<C-w>W", { desc = "Switch Window" })
map("n", "<leader>k", ":norm! K<cr>", { desc = "Keywordprg" })
map("n", "<leader>v", ":vsplit<cr>", { desc = "Vertical Split" })
map("n", "<leader>bs", scratch, { desc = "Scratch Buffer" })
map("n", "<leader>rc", ":<C-p><cr>", { desc = "Repeat Command" })
map("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>//g<left><left>]], { desc = "Replace Word" })

vim.cmd([[cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<down>"]])
vim.cmd([[cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<up>"]])
vim.keymap.del("n", "<leader>K")
