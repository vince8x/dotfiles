-- Using lazy.nvim
return {
  {
    "S1M0N38/ctx.nvim",
    version = "*",
    opts = {},
    keys = {

      -- Add visual selection to Quickfix List
      {
        "<localleader>q",
        function()
          local item = require("ctx.items").selection()
          require("ctx.utils").highlight(item)
          vim.fn.setqflist({ item }, "a")
        end,
        desc = "Add to Quickfix List",
        mode = { "v" },
      },
      -- Add visual selection to Location List
      {
        "<localleader>l",
        function()
          local win = vim.api.nvim_get_current_win()
          local item = require("ctx.items").selection()
          require("ctx.utils").highlight(item)
          vim.fn.setloclist(win, { item }, "a")
        end,
        desc = "Add to Location List",
        mode = { "v" },
      },
      -- There are other ways to send items to Quickfix / Location list.
      -- For example, many pickers (telescope, fzf-lua, snacks.picker) can
      -- send items to Quickfix / Location list.

      -- Yank Quickfix List to clipboard register
      {
        "yq",
        function()
          local md = require("ctx").qflist_to_md()
          vim.fn.setreg("+", md)
          vim.notify("Yanked qflist")
        end,
        desc = "Yank Quickfix List",
      },
      -- Yank Location List to clipboard register
      {
        "yl",
        function()
          local nr = vim.api.nvim_get_current_win()
          local md = require("ctx").loclist_to_md(nr)
          vim.fn.setreg("+", md)
          vim.notify("Yanked loclist")
        end,
        desc = "Yank Quickfix List",
      },

      -- Suggestions for Quickfix List navigation
      -- { "[q", vim.cmd.cprev, desc = "Previous Quickfix item" },
      -- { "]q", vim.cmd.cnext, desc = "Next Quickfix item" },
      -- { "[Q", vim.cmd.colder, desc = "Older Quickfix list" },
      -- { "]Q", vim.cmd.cnewer, desc = "Newer Quickfix list" },
      -- Suggestions for Location List navigation
      { "[l", vim.cmd.lprev, desc = "Previous Location item" },
      { "]l", vim.cmd.lnext, desc = "Next Location item" },
      { "[L", vim.cmd.lolder, desc = "Older Location list" },
      { "]L", vim.cmd.lnewer, desc = "Newer Location list" },
    },
  },
  {
    "0xrusowsky/nvim-ctx-ingest",
    dependencies = {
      "nvim-web-devicons", -- required for file icons
    },
    config = function()
      require("nvim-ctx-ingest").setup({
        -- your config options here
      })
    end,
    cmd = "CtxIngest",
    keys = { -- Example mapping to toggle outline
      { "<leader>ci", "<cmd>CtxIngest<CR>", desc = "Toggle [C]tx [I]ngest" },
    },
  },
  {
    "rmunozan/cosh.nvim",
    cmd = "Cosh",
  },
}
