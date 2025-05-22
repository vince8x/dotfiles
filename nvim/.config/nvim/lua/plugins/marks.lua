return {
  {
    "shihanng/recall.nvim",
    branch = "snacks-picker",
    config = function()
      local recall = require("recall")

      recall.setup({
        sign = "",
        sign_highlight = "@label",

        snacks = {
          mappings = {
            unmark_selected_entry = {
              insert = "<C-d>",
            },
          },
        },
      })

      vim.keymap.set("n", "<leader>ml", require("recall.snacks").pick, { noremap = true, silent = true })
      vim.keymap.set("n", "<f16>mm", recall.toggle, { noremap = true, silent = true })
      vim.keymap.set("n", "<f16>mn", recall.goto_next, { noremap = true, silent = true })
      vim.keymap.set("n", "<f16>mp", recall.goto_prev, { noremap = true, silent = true })
      vim.keymap.set("n", "<f16>mc", recall.clear, { noremap = true, silent = true })
    end,
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
