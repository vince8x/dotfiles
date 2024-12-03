return {
  {
    "fdschmidt93/telescope-egrepify.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = {
      { "<localleader>,", "<Cmd>Telescope egrepify<CR>", desc = "Search Text" },
    },
    config = function()
      require("telescope").load_extension("egrepify")
    end,
  },
}
