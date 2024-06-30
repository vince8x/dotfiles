-- Use your favorite package manager to install, for example in lazy.nvim
--  Optionally, you can also install nvim-telescope/telescope.nvim to use some search functionality.
return {
  {
    "sourcegraph/sg.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },

    keys = {
      {
        "<localleader>sf",
        "<cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>",
        desc = "Sourcegraph fuzzy search results",
      },
    },
    opts = {
      enable_cody = true,
      accept_tos = true,
      diagnostics = {
        enable = true,
        severity = {
          error = "Error",
          warning = "Warning",
          hint = "Hint",
          information = "Information",
        },
      },
    },
  },
}
