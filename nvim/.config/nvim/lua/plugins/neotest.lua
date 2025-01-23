return {
  {
    "nvim-neotest/neotest",
    -- stylua: ignore
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "haydenmeade/neotest-jest",
      "marilari88/neotest-vitest",
      "rouge8/neotest-rust"
    },
    opts = function(_, opts)
      table.insert(
        opts.adapters,
        require("neotest-vitest")({
          -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
          filter_dir = function(name, rel_path, root)
            return name ~= "node_modules"
          end,
        })
      )
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        })
      )
      table.insert(
        opts.adapters,
        require("neotest-rust")({
          args = { "--no-capture" },
        })
      )
    end,
    keys = {
      {
        "<leader>td",
        function()
          require("neotest").run.run({ stategy = "dap", suite = false })
        end,
        desc = "Debug test",
      },
      {
        "<leader>twr",
        function()
          require("neotest").run.run({ suite = true, vitestCommand = "vitest --watch" })
        end,
        desc = "Run watch",
      },
      {
        "<leader>twf",
        function()
          require("neotest").run.run({ suite = false, vim.fn.expand("%"), vitestCommand = "vitest --watch" })
        end,
        desc = "Run Watch File",
      },
      {
        "<t",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Next failed test",
      },
      {
        ">t",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Prev failed test",
      },
    },
  },
}
