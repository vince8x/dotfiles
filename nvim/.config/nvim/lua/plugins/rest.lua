return {
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    keys = {
      { "<localleader>R", "", desc = "+Rest" },
      { "<localleader>Rs", "<cmd>lua require('kulala').run()<cr>", desc = "Send the request" },
      { "<localleader>Rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle headers/body" },
      { "<localleader>Rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Jump to previous request" },
      { "<localleader>Rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Jump to next request" },
    },
  },
}
