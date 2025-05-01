return {
  {
    "Vigemus/iron.nvim",
    config = function()
      require("iron.core").setup({
        config = {
          scratch_repl = true,
          repl_open_cmd = require("iron.view").bottom(20),
          ignore_blank_lines = true,
        },
      })
    end,
    keys = {
      {
        "<leader>rp",
        desc = "REPL",
      }, 
      {
        "<leader>rpf",
        function()
          require("iron.core").send_file()
        end,
        desc = "REPL file",
      },
      {
        "<leader>rpl",
        function()
          require("iron.core").send_line()
        end,
        desc = "REPL line",
      },
      {
        "<leader>rpl",
        function()
          require("iron.core").visual_send()
        end,
        mode = { "x" },
        desc = "REPL lines",
      },
      {
        "<leader>rpc",
        function()
          require("iron.core").send(nil, string.char(12))
        end,
        desc = "REPL clear",
      },
      {
        "<leader>rpq",
        function()
          require("iron.core").close_repl()
        end,
        desc = "REPL quit",
      },
    },
  },
}
