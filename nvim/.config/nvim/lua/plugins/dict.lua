return {
  "jalvesaq/dict.nvim",
  keys = {
    { "<localleader>ct", "<cmd>lua require('dict').lookup()<cr>", desc = "Dictionary Lookup" },
  },
  config = function()
    require("dict").setup({
      dict_dir = '/usr/bin/dictd',
      cache_dir = os.getenv('HOME') .. '/.cache/dict.nvim',
    })
  end,
}
