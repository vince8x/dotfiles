return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "groovy" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        groovyls = {
          settings = {
            groovy = {
              classpath = {
                "~/.local/share/nvim/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar",
              },
            },
          },
        },
      },
    },
  },
}
