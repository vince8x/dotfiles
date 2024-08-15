-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local vim = vim
local opt = vim.opt
local g = vim.g
vim.opt.winbar = "%=%m %f"
vim.opt.swapfile = false

vim.g.matchparen_timeout = 20
vim.g.matchparen_insert_timeout = 20

vim.g.maplocalleader = ","

-- vim.g.lazyvim_picker = "fzf"
vim.g.codeium_manual = true
vim.g.codeium_render = false

vim.g.markdown_fenced_languages = {
  "html",
  "javascript",
  "typescript",
  "css",
  "scss",
  "lua",
  "vim",
  "sh",
}

vim.diagnostic.config({
  float = { border = "rounded" }, -- add border to diagnostic popups
})

local options = {
  --keywordprg = ':help',
  equalalways = true,
  winbar = "%=%m %F",
  nrformats = { "alpha", "octal", "hex" },
  virtualedit = "block",
  modelines = 5,
  modelineexpr = false,
  modeline = true,
  cursorline = false,
  cursorcolumn = false,
  splitright = true,
  splitbelow = true,
  smartcase = true,
  hlsearch = true,
  ignorecase = true,
  incsearch = true,
  inccommand = "nosplit",
  hidden = true,
  autoindent = true,
  termguicolors = true,
  showmode = false,
  showmatch = true,
  matchtime = 2,
  wildmode = "longest:full,full",
  number = true,
  linebreak = true,
  joinspaces = false,
  -- timeoutlen = 500,
  ttimeoutlen = 10, -- https://vi.stackexchange.com/a/4471/7339
  path = vim.opt.path + "**",
  isfname = vim.opt.isfname:append("@-@"),
  autochdir = true,
  relativenumber = true,
  numberwidth = 2,
  shada = "!,'50,<50,s10,h,r/tmp",
  expandtab = true,
  smarttab = true,
  smartindent = true,
  shiftround = true,
  shiftwidth = 2,
  tabstop = 2,
  foldenable = false,
  foldlevel = 99,
  foldlevelstart = 99,
  foldcolumn = "1",
  foldmethod = "expr",
  foldexpr = "nvim_treesitter#foldexpr()",
  undodir = os.getenv("HOME") .. "/.vim/undodir",
  undofile = true,
  showtabline = 0,
  mouse = "a",
  mousescroll = "ver:2,hor:6",
  scrolloff = 8,
  sidescrolloff = 3,
  wrap = false,
  list = true,
  -- listchars = { leadmultispace = "│ ", multispace = "│ ", tab = "│ ", },
  --lazyredraw = true,
  updatetime = 250,
  laststatus = 3,
  confirm = false,
  conceallevel = 3,
  cmdheight = 0,
  -- filetype = 'on', -- handled by filetypefiletype = 'on' --lugin
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

if vim.fn.executable("rg") then
  -- if ripgrep installed, use that as a grepper
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

if vim.fn.executable("prettier") then
  opt.formatprg = "prettier --stdin-filepath=%"
end

opt.formatoptions = "l"
opt.formatoptions = opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore

opt.guicursor = {
  "n-v:block",
  "i-c-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "i:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
  "sm:block-blinkwait175-blinkoff150-blinkon175",
}

-- window-local options
window_options = {
  numberwidth = 2,
  number = true,
  relativenumber = true,
  linebreak = true,
  cursorline = false,
  foldenable = false,
}

for k, v in pairs(window_options) do
  vim.wo[k] = v
end

vim.g.lazyvim_php_lsp = "intelephense"

-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff_lsp"
vim.g.autoformat = false

vim.filetype.add({
    extension = {
        Jenkinsfile = "groovy",
    },
})

vim.filetype.add({
    extension = {
        Jenkinsfile = "groovy",
    },
})
