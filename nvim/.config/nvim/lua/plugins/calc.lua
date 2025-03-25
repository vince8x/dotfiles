return {
  { -- qalc integration
    "Apeiros-46B/qalc.nvim",
    cmd = { "Qalc", "QalcAttach" },
    config = function()
      require("qalc").setup({})
      vim.keymap.set("n", "<localleader>qc", "<cmd>Qalc<CR>", { desc = "Start Qalculate" })
    end,
    init = function()
      -- lazy loading for specific file extension
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = { "*.qalc" },
        command = "QalcAttach",
      })
    end,
    keys = {
      { "<localleader>qn", "<cmd>vs | Qalc<CR>'<CR>", desc = "Start Qalculate" },
      { "<localleader>qa", "<cmd>QalcAttach<CR>", desc = "Attach Qalculate" },
      { "<localleader>qy", "<cmd>QalcYank<CR>", desc = "Send Qalculate" },
    },
  },
}
