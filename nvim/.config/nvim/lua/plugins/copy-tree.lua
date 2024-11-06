return {
  "AdiY00/copy-tree.nvim",
  cmd = "CopyTree",
  config = function()
    require("copy-tree").setup()
  end,
  -- Example keymap  
  vim.keymap.set("n", "<leader>ct", "<cmd>CopyTree<cr>", { desc = "Copy project structure from current directory" }),
}
