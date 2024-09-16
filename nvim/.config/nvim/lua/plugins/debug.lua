-- https://www.reddit.com/r/neovim/comments/1fgq6rq/lazyvim_python_debug_setup/

local js_based_languages = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
}

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Install the vscode-js-debug adapter
      {
        "microsoft/vscode-js-debug",
        -- After install, build it and rename the dist directory to out
        build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
        version = "1.*",
      },
      {
        "mxsdev/nvim-dap-vscode-js",
        config = function()
          ---@diagnostic disable-next-line: missing-fields
          require("dap-vscode-js").setup({
            -- Path of node executable. Defaults to $NODE_PATH, and then "node"
            -- node_path = "node",

            -- Path to vscode-js-debug installation.
            debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),

            -- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
            -- debugger_cmd = { "js-debug-adapter" },

            -- which adapters to register in nvim-dap
            adapters = {
              "chrome",
              "pwa-node",
              "pwa-chrome",
              "pwa-msedge",
              "pwa-extensionHost",
              "node-terminal",
            },

            -- Path for file logging
            -- log_file_path = "(stdpath cache)/dap_vscode_js.log",

            -- Logging level for output to file. Set to false to disable logging.
            -- log_file_level = false,

            -- Logging level for output to console. Set to false to disable console output.
            -- log_console_level = vim.log.levels.ERROR,
          })
        end,
      },
      {
        "Joakker/lua-json5",
        build = "./install.sh",
      },
    },
    config = function()
      local dap = require("dap")
      local Config = require("lazyvim.config")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          -- Debug single nodejs files
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug nodejs processes (make sure to add --inspect when you run the process)
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug web applications (client side)
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
          },
          -- Divider for the launch.json derived configs
          {
            name = "----- ↓ launch.json configs ↓ -----",
            type = "",
            request = "launch",
          },
        }
      end
    end,
    keys = function()
      return {
        { "<leader>d", "", desc = "+debug", mode = { "n", "v" } },
        {
          "<leader>da",
          function()
            if vim.fn.filereadable(".vscode/launch.json") then
              local dap_vscode = require("dap.ext.vscode")
              dap_vscode.load_launchjs(nil, {
                ["pwa-node"] = js_based_languages,
                ["chrome"] = js_based_languages,
                ["pwa-chrome"] = js_based_languages,
              })
            end
            require("dap").continue()
          end,
          desc = "Run with Args",
        },
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
  {
    "mfussenegger/nvim-dap-python",
    keys = {
      -- **Test-Related Key Mappings**
      {
        mode = "n",
        "<leader>dm",
        function()
          require("dap-python").test_method()
        end,
        desc = "Debug Test Method",
      },
      {
        mode = "n",
        "<leader>dc",
        function()
          require("dap-python").test_class()
        end,
        desc = "Debug Test Class",
      },
      -- **File-Related Key Mappings**
      {
        mode = "n",
        "<leader>df",
        function()
          require("dap-python").debug_file()
        end,
        desc = "Debug Python File",
      },

      -- **Function-Related Key Mappings**
      {
        mode = "n",
        "<leader>du",
        function()
          -- Custom function to debug the function under the cursor
          local dap_python = require("dap-python")
          local utils = require("dap-python.utils")
          local path = vim.fn.expand("%:p")
          local row = vim.fn.line(".")
          local func_name = utils.get_func_at_line(path, row)
          if func_name then
            dap_python.debug_at_point()
          else
            print("No function found under cursor.")
          end
        end,
        desc = "Debug Function Under Cursor",
      },

      -- **Class-Related Key Mappings**
      {
        mode = "n",
        "<leader>dk",
        function()
          -- Custom function to debug the class under the cursor
          local dap_python = require("dap-python")
          local utils = require("dap-python.utils")
          local path = vim.fn.expand("%:p")
          local row = vim.fn.line(".")
          local class_name = utils.get_class_at_line(path, row)
          if class_name then
            dap_python.debug_at_point()
          else
            print("No class found under cursor.")
          end
        end,
        desc = "Debug Class Under Cursor",
      },
    },
    config = function()
      require("dap-python").setup(vim.g.python3_host_prog)
      require("dap-python").test_runner = "pytest"
    end,
  },
}
