-- Git commands
return {
  "tpope/vim-fugitive",
  dependencies = {
    "folke/which-key.nvim",
  },
  config = function()
    local wk = require("which-key")

    wk.add({
        { "<leader>gS", "<cmd>Git<CR>", desc = "View Git Status" },
        { "<leader>ga", "<cmd>Gwrite<CR>", desc = "Git add current file" },
        { "g.", "<cmd>GBrowse<CR>", desc = "View HTTP Link" },
    })
  end,
}
