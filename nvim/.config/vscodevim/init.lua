-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.maplocalleader = ","

local function vscode_action(cmd)
  return function() vscode.action(cmd) end
end

local keymap = vim.api.nvim_set_keymap
--keymap('i', 'jk', '<ESC>', {})

local opts = { noremap = true }

-- find file
vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
-- find in files
vim.keymap.set("n", "<leader>/", [[<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>]])
-- open symbol
vim.keymap.set("n", "<leader>ss", [[<cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>]])
-- view problem
vim.keymap.set("n", "<leader>xx", [[<cmd>call VSCodeNotify('workbench.actions.view.problems')<cr>]])
-- open file explorer in left sidebar
vim.keymap.set("n", "<leader>e", [[<cmd>call VSCodeNotify('workbench.view.explorer')<cr>]])
-- Code Action
vim.keymap.set("n", "<leader>ca", [[<cmd>call VSCodeNotify('editor.action.codeAction')<cr>]])
-- Open terminal
vim.keymap.set("n", "<leader>ft", [[<cmd>call VSCodeNotify('workbench.action.terminal.focus')<cr>]])
vim.keymap.set({ "n", "x" }, "<leader>cr", "<cmd>call VSCodeNotify('editor.action.rename')<cr>")
vim.keymap.set("n", "<leader>fm", "<cmd>call VSCodeNotify('editor.action.formatDocument')<cr>")
vim.keymap.set("n", "<leader>co", "<cmd>call VSCodeNotify('editor.action.organizeImports')<cr>")
vim.keymap.set("n", "H", "<cmd>call VSCodeNotify('workbench.action.previousEditor')<cr>")
vim.keymap.set("n", "L", "<cmd>call VSCodeNotify('workbench.action.nextEditor')<cr>")

--keymap('n', '<c-j>', '<c-w>j', opts)
keymap("n", "zM", ':call VSCodeNotify("editor.foldAll")<CR>', opts)
keymap("n", "zR", ':call VSCodeNotify("editor.unfoldAll")<CR>', opts)
keymap("n", "zc", ':call VSCodeNotify("editor.fold")<CR>', opts)
keymap("n", "zC", ':call VSCodeNotify("editor.foldRecursively")<CR>', opts)
keymap("n", "zO", ':call VSCodeNotify("editor.unfoldRecursively")<CR>', opts)
keymap("n", "zo", ':call VSCodeNotify("editor.unfold")<CR>', opts)
keymap("n", "za", ':call VSCodeNotify("editor.toggleFold")<CR>', opts)
--keymap('n', '<space>', ':call VSCodeNotify("workbench.action.quickOpen")<CR>', opts)
