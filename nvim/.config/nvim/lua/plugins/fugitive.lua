-- Git commands
return {
  "tpope/vim-fugitive",
  dependencies = {
    "folke/which-key.nvim",
  },
  config = function()
    local wk = require("which-key")

    wk.register({
      ["<leader>gS"] = { "<cmd>Git<CR>", "View Git Status" },
      ["g."] = { "<cmd>GBrowse<CR>", "View HTTP Link" },
    })

    wk.register({
      ["g,"] = { "<cmd>GBrowse<CR>", "View HTTP Link" },
    }, { mode = "v" })
  end,
}
