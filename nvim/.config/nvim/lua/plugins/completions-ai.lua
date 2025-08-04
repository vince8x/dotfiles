return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    build = ":SupermavenUsePro",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<M-i>",
          accept_word = "<M-e>",
          clear_suggestion = "<M-c>",
        },
        color = {
          suggestion_color = "#b85b56",
          cterm = 244,
        },
        condition = function()
          local filetypes = { "md", "mdc" }
          return vim.tbl_contains(filetypes, vim.fn.expand("%:e"))
        end,
      })
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        virtualtext = {
          auto_trigger_ft = {},
          keymap = {
            -- accept whole completion
            accept = "<M-y>",
            -- accept one line
            accept_line = "<M-a>",
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            accept_n_lines = "<M-z>",
            -- Cycle to prev completion item, or manually invoke completion
            prev = "<M-[>",
            -- Cycle to next completion item, or manually invoke completion
            next = "<M-]>",
            dismiss = "<M-e>",
          },
        },
        provider_options = {
          codestral = {
            optional = {
              stop = { "\n\n" },
              max_tokens = 256,
            },
          },
          gemini = {
            optional = {
              generationConfig = {
                maxOutputTokens = 256,
                topP = 0.9,
              },
              safetySettings = {
                {
                  category = "HARM_CATEGORY_DANGEROUS_CONTENT",
                  threshold = "BLOCK_NONE",
                },
                {
                  category = "HARM_CATEGORY_HATE_SPEECH",
                  threshold = "BLOCK_NONE",
                },
                {
                  category = "HARM_CATEGORY_HARASSMENT",
                  threshold = "BLOCK_NONE",
                },
                {
                  category = "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                  threshold = "BLOCK_NONE",
                },
              },
            },
          },
          openai = {
            optional = {
              max_tokens = 256,
              top_p = 0.9,
            },
          },
          openai_compatible = {
            api_key = "OPENROUTER_API_KEY",
            end_point = "https://openrouter.ai/api/v1/chat/completions",
            model = "inception/mercury",
            name = "Openrouter",
            optional = {
              max_tokens = 56,
              top_p = 0.9,
              provider = {
                -- Prioritize throughput for faster completion
                sort = "throughput",
              },
            },
          },
          groq = {
            api_key = "GROQ_API_KEY",
            end_point = "https://api.groq.com/v1/chat/completions",
            model = "moonshotai/kimi-k2-instruct",
            name = "Groq",
            optional = {
              max_tokens = 56,
              top_p = 0.9,
              provider = {
                -- Prioritize throughput for faster completion
                sort = "throughput",
              },
            },
          },
          cerebras = {
            api_key = "CEREBRAS_API_KEY",
            end_point = "https://api.cerebras.net/v1/chat/completions",
            model = "qwen-3-coder-480b",
            name = "Cerebras",
            optional = {
              max_tokens = 56,
              top_p = 0.9,
              provider = {
                -- Prioritize throughput for faster completion
                sort = "throughput",
              },
            },
          },
        },
      })
    end,
  },
  -- {
  --   "augmentcode/augment.vim",
  --   init = function()
  --     vim.g.augment_disable_tab_mapping = true
  --     vim.keymap.set("v", "<leader>agv", function()
  --       local text = vim.fn.getreg("*") -- or vim.fn.getreg('"') for the unnamed register
  --       vim.cmd("Augment chat " .. vim.fn.shellescape(text))
  --     end, { desc = "Augment chat with visual selection" })
  --   end,
  --   keys = {
  --     { "<leader>ag", desc = "Augment chat +" },
  --     {
  --       "<leader>al",
  --       "<cmd>Augment chat " .. vim.api.nvim_get_current_line() .. "<CR>",
  --       desc = "Augment chat with current line",
  --     },
  --     { "<leader>agc", "<cmd>Augment chat<CR>", mode = { "n", "v" }, desc = "Augment chat" },
  --     { "<leader>agt", "<cmd>Augment chat-toggle<CR>", desc = "Toggle Augment chat" },
  --     { "<leader>agn", "<cmd>Augment chat-new<CR>", desc = "New Augment chat" },
  --     { "<M-y>", "<cmd>call augment#Accept()<CR>", mode = "i", noremap = true, silent = true },
  --   },
  -- },
}
