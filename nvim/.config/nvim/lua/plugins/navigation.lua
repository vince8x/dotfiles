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
}
