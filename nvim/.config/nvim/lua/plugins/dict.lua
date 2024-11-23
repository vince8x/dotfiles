return {
  {
    "jalvesaq/dict.nvim",
    keys = {
      { "<localleader>sl", "<cmd>lua require('dict').lookup()<cr>", desc = "Dictionary Lookup" },
    },
    config = function()
      require("dict").setup({
        dict_dir = "/usr/bin/dictd",
        cache_dir = os.getenv("HOME") .. "/.cache/dict.nvim",
      })
    end,
  },
  {
    "Nealium/dict-popup.nvim",
    opts = {
      normal_mapping = "<localleader>h",
      visual_mapping = "<localleader>h",
      visual_reg = "*",
      stack = false,
    },
  },
}
