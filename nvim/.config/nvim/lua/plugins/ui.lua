return {
  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false },
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
}
