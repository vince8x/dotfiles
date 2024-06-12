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
