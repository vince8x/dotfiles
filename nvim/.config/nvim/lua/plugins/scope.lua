return {
  "tiagovla/scope.nvim",
  dependencies = {
    "akinsho/bufferline.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("scope").setup()
  end,
  keys = {
    { "<leader>.", "<Cmd>Telescope scope buffers<CR>", desc = "List buffers" },
    { "<leader>wm", "<Cmd>ScopeMoveBuf<CR>", desc = "List buffers" },
  },
}
