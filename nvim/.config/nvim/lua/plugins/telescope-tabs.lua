return {
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
}
