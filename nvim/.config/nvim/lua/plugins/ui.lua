return {
  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },
  {
    "davesavic/dadbod-ui-yank",
    dependencies = { "kristijanhusak/vim-dadbod-ui" },
    config = function()
      require("dadbod-ui-yank").setup()
    end,
    keys = {
      { "<localleader>yc", "<cmd>DBUIYankAsCSV<cr>", desc = "Yank csv" },
      { "<localleader>yj", "<cmd>DBUIYankAsJSON<cr>", desc = "Yank json" },
      { "<localleader>yx", "<cmd>DBUIYankAsXML<cr>", desc = "Yank xml" },
    },
  },
  {

    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        hint = "floating-big-letter",
        selection_chars = "TNSERIAOC<X>DHWYFU",
        filter_rules = {
          include_current_win = false,
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "notify" },

            -- if the file type is one of following, the window will be ignored
            buftype = {},
          },
        },
      })
    end,
    keys = {
      {
        "<localleader>w",
        function()
          local win = require("window-picker").pick_window()
          if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
          end
        end,
        desc = "Window Picker: Pick",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    lazy = true,
    config = function()
      require("neo-tree").setup({
        window = {
          mappings = {
            ["/"] = "noop",
          },
        },
      })
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({})
    end,
  },
  {
    "jinh0/eyeliner.nvim",
    config = function()
      require("eyeliner").setup({
        highlight_on_key = true,
      })
    end,
  },
  {
    "Wansmer/treesj",
    keys = { "<localleader>m", "<localleader>j", "<localleader>r" },
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require("treesj").setup({--[[ your config ]]
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
}
