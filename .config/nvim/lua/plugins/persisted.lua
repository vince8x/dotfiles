return {
  "olimorris/persisted.nvim",
  lazy = false, -- make sure the plugin is always loaded at startup
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"
    require("persisted").setup({
      autoload = true,
    })
    require("telescope").load_extension("persisted")
  end,
}
