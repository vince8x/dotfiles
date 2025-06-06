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

-- map("n", "<Cr>", "viw")

-- vim.keymap.set("n", "<localleader>", '<cmd>lua require("which-key").show("\\\\")<cr>')

-- move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Paste without overwriting register
vim.keymap.set("v", "p", '"_dP')

-- Copy text to " register
vim.keymap.set("n", "<leader>y", '"+y', { desc = 'Yank into " register' })
vim.keymap.set("v", "<leader>y", '"+y', { desc = 'Yank into " register' })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = 'Yank into " register' })

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- local cmd = "cat /tmp/whisper.nvim | tail -n 1 | xargs -0 | tr -d '\\n' | sed -e 's/^[[:space:]]*//'"
-- local function whisper()
--   vim.cmd("silent !whisper.nvim")
--   local result = vim.fn.system(cmd)
--   vim.fn.setreg("a", result)
-- end

-- inoremap
-- vim.api.nvim_set_keymap("i", "<C-M>", "<Cmd>lua whisper()<CR><C-R>a", { noremap = true, silent = true })

-- nnoremap
-- vim.api.nvim_set_keymap("n", "<C-M>", '<Cmd>lua whisper()<CR>"ap', { noremap = true, silent = true })

-- vnoremap
-- vim.api.nvim_set_keymap("v", "<C-M>", "c<Cmd>lua whisper()<CR><C-R>a", { noremap = true, silent = true })
-- use leader + x to chmod executable
-- vim.keymap.set("n", "<leader>chmo", "<cmd>!chmod +x %<CR>", { silent = true })
--
vim.api.nvim_set_keymap(
  "n",
  "<leader>To",
  ":Telescope project_cli_commands open<cr>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>Tr",
  ":Telescope project_cli_commands running<cr>",
  { noremap = true, silent = true }
)

-- wsnavigator
-- use buf_only
vim.keymap.set("n", "tt", function()
  local wsn = require("wsnavigator")
  wsn.set_opts({ jumplist = { buf_only = true } })
  wsn.open_wsn()
end, { noremap = true })

-- use jumplist
vim.keymap.set("n", "tj", function()
  local wsn = require("wsnavigator")
  wsn.set_opts({ jumplist = { buf_only = false } })
  wsn.open_wsn()
end, { noremap = true })

-- switch_display_mode
vim.keymap.set("n", "ts", function()
  local wsn = require("wsnavigator")
  wsn.switch_display_mode()
end, { noremap = true })

vim.api.nvim_set_keymap(
  "n",
  "<localleader>do",
  ":lua vim.diagnostic.open_float()<CR>",
  { noremap = true, silent = true }
)

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

-- Jump between markdown headers
vim.keymap.set("n", "gj", [[/^##\+ .*<CR>]], { buffer = true, silent = true })
vim.keymap.set("n", "gk", [[?^##\+ .*<CR>]], { buffer = true, silent = true })

-- Select all
vim.keymap.set("n", "==", "gg<S-v>G")

-- Make current file executable
vim.keymap.set("n", "<localleader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- Copy file paths
vim.keymap.set("n", "<localleader>cf", '<cmd>let @+ = expand("%")<CR>', { desc = "Copy File Name" })
vim.keymap.set("n", "<localleader>cp", '<cmd>let @+ = expand("%:p")<CR>', { desc = "Copy File Path" })

vim.keymap.set("n", "<localleader>sl", '<Cmd>lua require("dict").lookup()<CR>')

-- Zotero Citation Picker
function ZoteroCite()
  local url = '"http://127.0.0.1:23119/better-bibtex/cayw?format=pandoc&brackets=yes"'
  local handle = io.popen("curl -s " .. url)
  local citekey = handle:read("*a")
  citekey = citekey:gsub("[\n\r]", " ")
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { citekey })
end

map("i", "<A-z>", ZoteroCite)
map("n", "<leader>zz", ZoteroCite)

-- ############################################################################
--                         Begin of markdown section
-- ############################################################################

-- Keymap to auto-format and save all Markdown files in the CURRENT REPOSITORY,
-- lamw26wmal if the TOC is not updated, this will take care of it
vim.keymap.set("n", "<leader>mfA", function()
  -- Get the root directory of the git repository
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if not git_root or git_root == "" then
    print("Could not determine the root directory for the Git repository.")
    return
  end
  -- Find all Markdown files in the repository
  local find_command = string.format("find %s -type f -name '*.md'", vim.fn.shellescape(git_root))
  local handle = io.popen(find_command)
  if not handle then
    print("Failed to execute the find command.")
    return
  end
  local result = handle:read("*a")
  handle:close()
  if result == "" then
    print("No Markdown files found in the repository.")
    return
  end
  -- Format and save each Markdown file
  for file in result:gmatch("[^\r\n]+") do
    local bufnr = vim.fn.bufadd(file)
    vim.fn.bufload(bufnr)
    require("conform").format({ bufnr = bufnr })
    -- Save the buffer to write changes to disk
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("write")
    end)
    print("Formatted and saved: " .. file)
  end
end, { desc = "[P]Format and save all Markdown files in the repo" })

vim.keymap.set(
  "v",
  "<leader>mj",
  ":g/^\\s*$/d<CR>:nohlsearch<CR>",
  { desc = "[P]Delete newlines in selected text (join)" }
)
