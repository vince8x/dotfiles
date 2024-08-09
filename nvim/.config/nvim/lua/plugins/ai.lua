return {
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    enabled = true,
    config = function()
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-e>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-n>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- Optional
      {
        "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
        opts = {},
      },
    },
    opts = function(_, opts)
      opts.strategies = {
        chat = "openai",
        inline = "openai",
        tools = "openai",
      }
      opts.adapters = {
        anthropic = require("codecompanion.adapters").use("anthropic", {
          schema = {
            model = {
              default = "claude-3-5-sonnet-20240620",
            },
          },
        }),
        openai = require("codecompanion.adapters").use("openai", {
          env = {
            api_key = "OPENAI_API_KEY",
          },
        }),
      }
    end,
    keys = {
      { "<leader>Aa", "<cmd>CodeCompanionActions<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>Aa", "<cmd>CodeCompanionActions<cr>", mode = "v", noremap = true, silent = true },
      { "<leader>AA", "<cmd>CodeCompanionToggle<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>AA", "<cmd>CodeCompanionToggle<cr>", mode = "v", noremap = true, silent = true },
      { "<leader>A", "<cmd>CodeCompanionAdd<cr>", mode = "v", noremap = true, silent = true },
    },
  },
  {
    "joshuavial/aider.nvim",
    opts = {
      auto_manage_context = true,
      default_bindings = true,
    },
    keys = {
      {
        "<leader>aoa",
        function()
          require("aider").AiderOpen()
        end,
        desc = "Aider Open",
      },
      {
        "<leader>aob",
        function()
          require("aider").AiderBackground()
        end,
        desc = "Aider Background",
      },
    },
  },
  {
    "github/copilot.vim",
    enabled = false,
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "pass show apikey/openai",
        keymaps = {
          submit = "<C-j>",
          yank_last_code = "<C-y>",
        },
      })
      require("which-key").add({
        {
          { "<leader>o", group = "OpenAI's ChatGPT" },
          { "<leader>oc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
          {
            mode = { "n", "v" },
            { "<leader>oa", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
            { "<leader>od", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
            { "<leader>oe", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" },
            { "<leader>of", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
            { "<leader>og", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction" },
            { "<leader>ok", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" },
            { "<leader>ol", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
            { "<leader>oo", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" },
            { "<leader>or", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" },
            { "<leader>os", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
            { "<leader>ot", "<cmd>ChatGPTRun translate<CR>", desc = "Translate" },
            { "<leader>ox", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
          },
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  -- {
  --   "frankroeder/parrot.nvim",
  --   disabled = true,
  --   tag = "v0.3.1",
  --   dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
  --   config = function()
  --     require("parrot").setup({
  --       providers = {
  --         -- pplx = {
  --         --   api_key = os.getenv("PERPLEXITY_API_KEY"),
  --         -- OPTIONAL
  --         -- gpg command
  --         -- api_key = { "gpg", "--decrypt", vim.fn.expand("$HOME") .. "/pplx_api_key.txt.gpg"  },
  --         -- macOS security tool
  --         -- api_key = { "/usr/bin/security", "find-generic-password", "-s pplx-api-key", "-w" },
  --         -- },
  --         openai = {
  --           api_key = os.getenv("OPENAI_API_KEY"),
  --         },
  --         -- anthropic = {
  --         --   api_key = os.getenv("ANTHROPIC_API_KEY"),
  --         -- },
  --         -- mistral = {
  --         --   api_key = os.getenv("MISTRAL_API_KEY"),
  --         -- },
  --       },
  --     })
  --   end,
  -- },
}
