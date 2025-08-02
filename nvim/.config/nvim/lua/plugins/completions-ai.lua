return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    build = ":SupermavenUsePro",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<M-i>",
          accept_word = "<M-e>",
          clear_suggestion = "<M-c>",
        },
        color = {
          suggestion_color = "#b85b56",
          cterm = 244,
        },
        condition = function()
          local filetypes = { "md", "mdc" }
          return vim.tbl_contains(filetypes, vim.fn.expand("%:e"))
        end,
      })
    end,
  },
  -- {
  --   "augmentcode/augment.vim",
  --   init = function()
  --     vim.g.augment_disable_tab_mapping = true
  --     vim.keymap.set("v", "<leader>agv", function()
  --       local text = vim.fn.getreg("*") -- or vim.fn.getreg('"') for the unnamed register
  --       vim.cmd("Augment chat " .. vim.fn.shellescape(text))
  --     end, { desc = "Augment chat with visual selection" })
  --   end,
  --   keys = {
  --     { "<leader>ag", desc = "Augment chat +" },
  --     {
  --       "<leader>al",
  --       "<cmd>Augment chat " .. vim.api.nvim_get_current_line() .. "<CR>",
  --       desc = "Augment chat with current line",
  --     },
  --     { "<leader>agc", "<cmd>Augment chat<CR>", mode = { "n", "v" }, desc = "Augment chat" },
  --     { "<leader>agt", "<cmd>Augment chat-toggle<CR>", desc = "Toggle Augment chat" },
  --     { "<leader>agn", "<cmd>Augment chat-new<CR>", desc = "New Augment chat" },
  --     { "<M-y>", "<cmd>call augment#Accept()<CR>", mode = "i", noremap = true, silent = true },
  --   },
  -- },
}
