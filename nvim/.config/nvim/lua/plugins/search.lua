return {
  {
    "hamidi-dev/kaleidosearch.nvim",
    dependencies = {
      "tpope/vim-repeat", -- optional for dot-repeatability
      "stevearc/dressing.nvim", -- optional for nice input
    },

    config = function()
      require("kaleidosearch").setup({
        highlight_group_prefix = "WordColor_", -- Prefix for highlight groups
        case_sensitive = false, -- Case sensitivity for matching
        keymaps = {
          enabled = true, -- Set to false to disable default keymaps
          open = "<localleader>cs", -- Open input prompt for search
          clear = "<localleader>cx", -- Clear highlights
          add_new_word = "<localleader>cn", -- Add a new word to existing highlights
          add_cursor_word = "<localleader>ca", -- Add word under cursor to highlights
          opts = {
            noremap = true,
            silent = true,
          },
        }, -- optional configuration
      })
    end,
  },
}
