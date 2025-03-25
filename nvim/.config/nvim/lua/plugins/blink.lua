return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "enter",
      },
    },
    sources = {
      default = { ..., "context_nvim" }, -- to add the context_nvim source to all filetypes
      per_filetype = { codecompanion = { "context_nvim", markdown = "context_nvim" } }, -- to add the context_nvim source to a specific filetype
      providers = {
        context_nvim = {
          enabled = true,
          name = "context_nvim",
          module = "context_nvim.blink_source",
        },
      },
    },
  },
}
