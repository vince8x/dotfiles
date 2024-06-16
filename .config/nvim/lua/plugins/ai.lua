return {
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    enabled = false,
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "pass show apikey/openai",
        keymaps = {
          submit = "<C-j>",
          yank_last_code = "<C-y>",
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
}
