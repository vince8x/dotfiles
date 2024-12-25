return {
  "philosofonusus/ecolog.nvim",
  dependencies = {
    "hrsh7th/nvim-cmp", -- Optional, for autocompletion support
  },
  -- Optionally reccommend adding keybinds (I use them personally)
  keys = {
    { "<leader>qge", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
    { "<leader>qes", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
    { "<leader>qep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
  },
  lazy = false,
  opts = {
    -- Enables shelter mode for sensitive values
    shelter = {
      configuration = {
        partial_mode = false, -- Disables partial mode see shelter configuration below
        mask_char = "*", -- Character used for masking
      },
      modules = {
        cmp = true, -- Mask values in completion
        peek = false, -- Mask values in peek view
        files = false, -- Mask values in files
        telescope = false, -- Mask values in telescope
      },
    },
    path = vim.fn.getcwd(), -- Path to search for .env files
    preferred_environment = "development", -- Optional: prioritize specific env files
  },
}