return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
      -- ... Other dependencies
      config = function()
        vim.api.nvim_set_hl(0, "BlinkCmpKindAvante", { default = false, fg = "#89b4fa" })
        vim.api.nvim_set_hl(0, "BlinkCmpKindAvanteCmd", { default = false, fg = "#89b4fa" })
        vim.api.nvim_set_hl(0, "BlinkCmpKindAvanteMention", { default = false, fg = "#89b4fa" })
      end,
    },
    opts = {
      keymap = {
        preset = "enter",
      },
    },
    sources = {
      default = { ..., "supermaven", "avante", "context_nvim" }, -- to add the context_nvim source to all filetypes
      per_filetype = { codecompanion = { "context_nvim", markdown = "context_nvim" } }, -- to add the context_nvim source to a specific filetype
      providers = {
        supermaven = {
          name = "supermaven",
          module = "blink.compat.source",
          score_offset = 3,
        },
        context_nvim = {
          enabled = true,
          name = "context_nvim",
          module = "context_nvim.blink_source",
        },
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {
            -- options for blink-cmp-avante
            avante = {
              command = {
                get_kind_name = function(_)
                  return "AvanteCmd"
                end,
              },
              mention = {
                get_kind_name = function(_)
                  return "AvanteMention"
                end,
              },
            },
            kind_icons = {
              AvanteCmd = "",
              AvanteMention = "@",
            },
          },
        },
      },
    },
  },
}
