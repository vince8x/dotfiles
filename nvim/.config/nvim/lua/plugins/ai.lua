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
  {},

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
    "nekowasabi/aider.vim",
    event = "VeryLazy",
    dependencies = {
      "vim-denops/denops.vim",
      event = { "VeryLazy" },
      "vim-denops/denops-helloworld.vim",
    },
    keys = {
      { "<localleader>ar", "<cmd>AiderRun<cr>", mode = "n", noremap = true, silent = true },
      { "<localleader>aa", "<cmd>AiderAddCurrentFile<cr>", mode = "n", noremap = true, silent = true },
      { "<localleader>aw", "<cmd>AiderAddWeb<cr>", mode = "n", noremap = true, silent = true },
      { "<localleader>ap", "<cmd>AiderSendPromptWithInput<cr>", mode = "n", noremap = true, silent = true },
      { "<localleader>ax", "<cmd>AiderExit<cr>", mode = "n", noremap = true, silent = true },
      { "<localleader>ai", "<cmd>AiderAddIgnoreCurrentFile<cr>", mode = "n", noremap = true, silent = true },
      { "<localleader>aI", "<cmd>AiderOpenIgnore<cr>", mode = "n", noremap = true, silent = true },
      { "<localleader>av", "<cmd>AiderVisualTextWithPrompt<cr>", mode = "v" },
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
        openai_params = {
          -- NOTE: model can be a function returning the model name
          -- this is useful if you want to change the model on the fly
          -- using commands
          -- Example:
          -- model = function()
          --     if some_condition() then
          --         return "gpt-4-1106-preview"
          --     else
          --         return "gpt-3.5-turbo"
          --     end
          -- end,
          model = "gpt-4-1106-preview",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 4095,
          temperature = 0.2,
          top_p = 0.1,
          n = 1,
        },
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
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    opts = {
      provider = "gemini",
      mappings = {
        ask = "<localleader>va",
        edit = "<localleader>ve",
        refresh = "<localleader>vr",
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          none = "c0",
          both = "cb",
          next = "]x",
          prev = "[x",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        toggle = {
          debug = "<localleader>vd",
          hint = "<localleader>vh",
        },
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      {
        "grapp-dev/nui-components.nvim",
        dependencies = {
          "MunifTanjim/nui.nvim",
        },
      },
      --- The below is optional, make sure to setup it properly if you have lazy=true
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    build = ":SupermavenUseFree",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<D-i>",
          accept_word = "<D-j>",
          clear_suggestion = "<D-c>",
        },
        color = {
          suggestion_color = "blue",
          cterm = 226,
        },
      })
    end,
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
