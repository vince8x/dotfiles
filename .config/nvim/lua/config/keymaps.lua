-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Move to window using the <ctrl> hjkl keys
local map = vim.keymap.set
map("n", "<C-.>", "<C-i>", { desc = "Go to Foward", noremap = true })
map("n", "<C-,>", "<C-o>", { desc = "Go to Backward", noremap = true })

-- map("n", "<C-m>", "<C-w>h", { desc = "Go to Left Window", remap = true })
-- map("n", "<C-n>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
-- map("n", "<C-e>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
-- map("n", "<C-i>", "<C-w>l", { desc = "Go to Right Window", remap = true })
--
vim.api.nvim_set_keymap("i", "<Up>", "<C-p>", { expr = true, noremap = true })
vim.api.nvim_set_keymap("i", "<Down>", "<C-n>", { expr = true, noremap = true })

map("n", "<Cr>", "viw")

vim.keymap.set("n", "<localleader>", '<cmd>lua require("which-key").show("\\\\")<cr>')

-- move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- use leader + x to chmod executable
-- vim.keymap.set("n", "<leader>chmo", "<cmd>!chmod +x %<CR>", { silent = true })
