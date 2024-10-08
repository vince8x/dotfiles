return {
  {
    "LukasPietzschmann/telescope-tabs",
    config = function()
      require("telescope").load_extension("telescope-tabs")
      require("telescope-tabs").setup({
        -- Your custom config :^)
      })
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>fa", "<cmd>Telescope telescope-tabs list_tabs<CR>", desc = "List tabs" },
    },
  },
  {
    "TC72/telescope-tele-tabby.nvim",
    config = function()
      require("telescope").load_extension("tele_tabby")
      require("tele_tabby").setup({
        use_highlighter = true,
        -- Your custom config :^)
      })
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>fA", "<cmd>Telescope tele_tabby list<CR>", desc = "List tele tabby" },
    },
  }
}
