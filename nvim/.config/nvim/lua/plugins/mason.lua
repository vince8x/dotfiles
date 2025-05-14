return {
  "mason-org/mason.nvim",
  version = "1.11.0",
  dependencies = {
    { "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
    "neovim/nvim-lspconfig",
  },
  opts = {
    -- Other mason settings...
  },
  -- This config function sets up mason-lspconfig
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    local function ensure_installed()
      for _, tool in ipairs(opts.ensure_installed) do
        -- ... (logic to install tools) ...
      end
    end
    -- ...

    -- *** THIS IS THE KEY PART ***
    require("mason-lspconfig").setup({
      -- List of servers Mason should automatically install
      ensure_installed = {
        "lua_ls",
        "bashls",
        -- Add your desired LSP server's MASON NAME here
        "circom-lsp",
        -- "pyright",
        -- "rust_analyzer",
        -- etc.
      },
      handlers = {
        -- Default handler using LazyVim's lspconfig setup
        -- function(server_name)
        --   require("lspconfig")[server_name].setup({
        --     capabilities = require("cmp_nvim_lsp").default_capabilities(),
        --     -- LazyVim applies its default on_attach and other settings here
        --   })
        -- end,

        -- == Optional: Add Custom Handler for Specific Server == --
        -- Use the LSPCONFIG NAME (underscores) if you need custom settings
        -- Add a custom handler for circom_lsp if needed:
        -- ["circom_lsp"] = function()
        --   require("lspconfig").circom_lsp.setup({
        --     capabilities = require("cmp_nvim_lsp").default_capabilities(),
        --     -- Add any circom_lsp specific settings filetypes, root_dir patterns etc.
        --     -- filetypes = { 'circom' }, -- Often picked up automatically
        --   })
        -- end,
      },
    })
  end,
}
