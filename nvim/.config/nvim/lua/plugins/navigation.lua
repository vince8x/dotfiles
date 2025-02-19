return {
  {
    "chrisgrieser/nvim-spider",
    vscode = true,
    keys = {
      -- { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" }, desc = "Spider-w" },
      -- { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" }, desc = "Spider-e" },
      -- { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" }, desc = "Spider-b" },
    },
    opts = {
      skipInsignificantPunctuation = false,
      consistentOperatorPending = true,
      subwordMovement = true,
      customPatterns = {},
    },
  },
  {
    "SmiteshP/nvim-navbuddy",
    keys = {
      {
        "<localleader>n",
        function()
          require("nvim-navbuddy").open()
        end,
      },
    },
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    opts = { lsp = { auto_attach = true } },
  },
  {
    "aaronik/treewalker.nvim",
    cmd = "Treewalker",
    keys = {
      {
        "<A-e>",
        function()
          require("treewalker").move_up()
        end,
        desc = "Up to prev neighbor node",
      },
      {
        "<A-n>",
        function()
          require("treewalker").move_down()
        end,
        desc = "Down to next neighbor node",
      },
      {
        "<A-m>",
        function()
          require("treewalker").move_out()
        end,
        desc = "Prev good child node",
      },
      {
        "<A-i>",
        function()
          require("treewalker").move_in()
        end,
        desc = "Next good child node",
      },
    },
    opts = {},
  },
  {
    "bassamsdata/namu.nvim",
    config = function()
      require("namu").setup({
        -- Enable the modules you want
        namu_symbols = {
          enable = true,
          options = {}, -- here you can configure namu
        },
        -- Optional: Enable other modules if needed
        colorscheme = {
          enable = false,
          options = {
            -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
            persist = true, -- very efficient mechanism to Remember selected colorscheme
            write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
          },
        },
        ui_select = { enable = false }, -- vim.ui.select() wrapper
      })
      -- === Suggested Keymaps: ===
      local namu = require("namu.namu_symbols")
      local colorscheme = require("namu.colorscheme")
      vim.keymap.set("n", "<f16>ss", namu.show, {
        desc = "Jump to LSP symbol",
        silent = true,
      })
      vim.keymap.set("n", "<leader>th", colorscheme.show, {
        desc = "Colorscheme Picker",
        silent = true,
      })
    end,
  },
}
