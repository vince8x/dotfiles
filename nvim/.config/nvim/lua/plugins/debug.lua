return {
  {
    "mfussenegger/nvim-dap",
    keys = function()
      return {
        { "<leader>d", "", desc = "+debug", mode = { "n", "v" } },
        {
          "<F5>",
          function()
            require("dap").continue()
          end,
          desc = "Debug start/continue",
        },
        {
          "<leader>da",
          function()
            require("dap").continue({ before = get_args })
          end,
          desc = "Run with Args",
        },
        {
          "<leader>dB",
          function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Breakpoint Condition",
        },
        {
          "<leader>db",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Toggle Breakpoint",
        },
        {
          "<leader>dg",
          function()
            require("dap").goto_()
          end,
          desc = "Go to Line (No Execute)",
        },
        {
          "<leader>dC",
          function()
            require("dap").run_to_cursor()
          end,
          desc = "Run to Cursor",
        },
        {
          "<leader>ds",
          function()
            require("dap").session()
          end,
          desc = "Session",
        },
        {
          "<F10>",
          function()
            require("dap").step_over()
          end,
          desc = "Debug step over",
        },
        {
          "<F9>",
          function()
            require("dap").step_into()
          end,
          desc = "Debug step into",
        },
        {
          "<F11>",
          function()
            require("dap").step_out()
          end,
          desc = "Debug step out",
        },
        {
          "<F4>",
          function()
            require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
          end,
          desc = "Debug set breakpoint log point message",
        },
        {
          "<F6>",
          function()
            require("dap").repl.open()
          end,
          desc = "Debug open repl",
        },
        {
          "<F7>",
          function()
            require("dap").run_last()
          end,
          desc = "Debug retun last",
        },
        {
          "<leader>dt",
          function()
            require("dap").terminate()
          end,
          desc = "Terminate",
        },
        {
          "<leader>dw",
          function()
            require("dap.ui.widgets").hover()
          end,
          desc = "Widgets",
        },
        {
          "F2",
          function()
            require("dap").repl.toggle()
          end,
          desc = "Toggle REPL",
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = function()
      return {
        {
          "<F12>",
          function()
            require("dapui").toggle()
          end,
          desc = "Debug UI",
        },
      }
    end,
  },
}
