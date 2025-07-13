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
  -- {
  --   "cordx56/rustowl",
  --   version = "*", -- Latest stable version
  --   build = "cd rustowl && cargo install --path . -F installer --locked",
  --   lazy = false, -- This plugin is already lazy
  --   opts = {
  --     client = {
  --       on_attach = function(_, buffer)
  --         vim.keymap.set("n", "<localleader>ro", function()
  --           require("rustowl").toggle(buffer)
  --         end, { buffer = buffer, desc = "Toggle RustOwl" })
  --       end,
  --     },
  --   },
  -- },
  {
    "iden3/vim-circom-syntax",
  },
  {
    "noir-lang/noir-nvim",
  },
}
