return {
  -- {
  --   "Exafunction/codeium.vim",
  --   event = "BufEnter",
  --   enabled = false,
  --   config = function()
  --     -- Change '<C-g>' here to any keycode you like.
  --     vim.keymap.set("i", "<C-y>", function()
  --       return vim.fn["codeium#Accept"]()
  --     end, { expr = true, silent = true })
  --     vim.keymap.set("i", "<C-e>", function()
  --       return vim.fn["codeium#CycleCompletions"](1)
  --     end, { expr = true, silent = true })
  --     vim.keymap.set("i", "<C-n>", function()
  --       return vim.fn["codeium#CycleCompletions"](-1)
  --     end, { expr = true, silent = true })
  --     vim.keymap.set("i", "<C-x>", function()
  --       return vim.fn["codeium#Clear"]()
  --     end, { expr = true, silent = true })
  --   end,
  -- },
  -- {},
  --
  {
    -- enabled = false,
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
    build = "bun install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    config = function()
      require("mcphub").setup({
        -- Required options
        port = 3000, -- Port for MCP Hub server
        config = vim.fn.expand("~/mcpservers.json"), -- Absolute path to config file

        -- Optional options
        on_ready = function(hub)
          -- Called when hub is ready
        end,
        on_error = function(err)
          -- Called on errors
        end,
        shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
      })
    end,
    keys = {
      { "<localleader>mh", "<cmd>MCPHub<CR>", desc = "Start MCP Hub" },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
      "ravitemer/mcphub.nvim",
    },
    config = function()
      require("codecompanion").setup({
        adapters = {
          deepseek = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://api.deepseek.com",
                api_key = "DEEPSEEK_API_KEY",
              },
            })
          end,
          groq = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = vim.env.GROQ_API_KEY,
              },
              name = "Groq",
              url = "https://api.groq.com/openai/v1/chat/completions",
              schema = {
                model = {
                  default = "mixtral-8x7b-32768",
                  choices = {
                    ["mixtral-8x7b-32768"] = "Mixtral 8x7B from Mistral",
                    ["llama-3.1-8b-instant"] = "LLAMA 3.1 instant from Meta",
                    ["llama-3.1-70b-versatile"] = "LLAMA 3.1 70B from Meta",
                    ["whisper-large-v3-turbo"] = "Whisper large from OpenAI",
                    ["gemma2-9b-it"] = "Gemma 2 9B from Google",
                    ["deepseek-r1-distill-llama-70b"] = "Deepseek R1 distill from Deepseek",
                    ["qwen-qwq-32b"] = "Qwen QWQ from Qwen",
                  },
                },
              },
              max_tokens = {
                default = 32768,
              },
              temperature = {
                default = 1,
              },
            })
          end,
          openrouter = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://openrouter.ai/api",
                api_key = "OPENROUTER_API_KEY",
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  default = "google/gemini-2.0-flash-001",
                },
                choices = {
                  ["google/gemini-2.0-flash-001"] = "Gemini 2.0 from Google",
                  ["anthropic/claude-3.5-sonnet"] = "Claude 3.5 from Anthropic",
                  ["anthropic/claude-3.7-sonnet"] = "Claude 3.7 from Anthropic",
                  ["deepseek/deekseek-chat-v3-0324"] = "Deepseek Chat v3 from Deepseek",
                  ["google/gemini-2.5-pro-exp-03-25:free"] = "Gemini 2.5 from Google",
                  ["qwen/qwen2.5-vl-32b-instruct:free"] = "Qwen 2.5 from Qwen",
                  ["qwen/qwq-32b:free"] = "Qwq 32b from Qwen",
                },
              },
            })
          end,
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              schema = {
                model = {
                  default = "gemini-2.5-pro-exp-03-25",
                },
                choices = {
                  ["gemini-2.0-flash-001"] = "Gemini 2.0 from Google",
                  ["gemini-2.5-pro-exp-03-25"] = "Gemini 2.5 from Google",
                },
              },
              env = {
                api_key = "GEMINI_API_KEY",
              },
            })
          end,
        },
        display = {
          diff = {
            provider = "mini_diff",
          },
        },
        strategies = {
          chat = {
            adapter = "deepseek",
            tools = {
              ["mcp"] = {
                -- calling it in a function would prevent mcphub from being loaded before it's needed
                callback = function()
                  return require("mcphub.extensions.codecompanion")
                end,
                description = "Call tools and resources from the MCP Servers",
                opts = {
                  requires_approval = true,
                },
              },
            },
          },
          inline = { adapter = "deepseek" },
          agent = { adapter = "deepseek" },
        },
        prompt_library = {
          ["Review code"] = {
            strategy = "chat",
            description = "Review the selected code",
            opts = {
              index = 11,
              is_default = true,
              is_slash_cmd = false,
              modes = { "v" },
              short_name = "review",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
          },
        },
      })
    end,
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    keys = {
      { "<localleader>Ca", "<cmd>CodeCompanionActions<cr>", mode = "n", noremap = true, silent = true },
      { "<localleader>Ca", "<cmd>CodeCompanionActions<cr>", mode = "v", noremap = true, silent = true },
      { "<localleader>Ct", "<cmd>CodeCompanionToggle<cr>", mode = "n", noremap = true, silent = true },
      { "<localleader>Ct", "<cmd>CodeCompanionToggle<cr>", mode = "v", noremap = true, silent = true },
      { "<localleader>CA", "<cmd>CodeCompanionAdd<cr>", mode = "v", noremap = true, silent = true },
    },
  },
  {
    "github/copilot.vim",
    enabled = false,
  },
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("chatgpt").setup({
  --       openai_params = {
  --         -- NOTE: model can be a function returning the model name
  --         -- this is useful if you want to change the model on the fly
  --         -- using commands
  --         -- Example:
  --         -- model = function()
  --         --     if some_condition() then
  --         --         return "gpt-4-1106-preview"
  --         --     else
  --         --         return "gpt-3.5-turbo"
  --         --     end
  --         -- end,
  --         model = "gpt-4-1106-preview",
  --         frequency_penalty = 0,
  --         presence_penalty = 0,
  --         max_tokens = 4095,
  --         temperature = 0.2,
  --         top_p = 0.1,
  --         n = 1,
  --       },
  --       keymaps = {
  --         submit = "<C-j>",
  --         yank_last_code = "<C-y>",
  --       },
  --     })
  --     require("which-key").add({
  --       {
  --         { "<leader>o", group = "OpenAI's ChatGPT" },
  --         { "<leader>oc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
  --         {
  --           mode = { "n", "v" },
  --           { "<leader>oa", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
  --           { "<leader>od", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
  --           { "<leader>oe", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" },
  --           { "<leader>of", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
  --           { "<leader>og", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction" },
  --           { "<leader>ok", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" },
  --           { "<leader>ol", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
  --           { "<leader>oo", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" },
  --           { "<leader>or", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" },
  --           { "<leader>os", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
  --           { "<leader>ot", "<cmd>ChatGPTRun translate<CR>", desc = "Translate" },
  --           { "<leader>ox", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
  --         },
  --       },
  --     })
  --   end,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "folke/trouble.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- },
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    build = ":SupermavenUsePro",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<M-i>",
          accept_word = "<M-j>",
          clear_suggestion = "<M-c>",
        },
      })
    end,
  },
  {
    "augmentcode/augment.vim",
    init = function()
      vim.g.augment_disable_tab_mapping = true
      vim.keymap.set("n", "<leader>al", function()
        vim.cmd("Augment chat " .. vim.api.nvim_get_current_line())
      end, { desc = "Augment chat with current line" })
      vim.keymap.set({ "n", "v" }, "<localleader>agc", "<cmd>Augment chat<CR>")
      vim.keymap.set("n", "<localleader>agt", "<cmd>Augment chat-toggle<CR>")
      vim.keymap.set("n", "<localleader>agn", "<cmd>Augment chat-new<CR>")
      vim.keymap.set("i", "<M-y>", "<cmd>call augment#Accept()<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = {
      "AiderTerminalToggle",
      "AiderHealth",
    },
    keys = {
      { "<f16>a/", "<cmd>AiderTerminalToggle<cr>", desc = "Open Aider" },
      { "<f16>as", "<cmd>AiderTerminalSend<cr>", desc = "Send to Aider", mode = { "n", "v" } },
      { "<f16>ac", "<cmd>AiderQuickSendCommand<cr>", desc = "Send Command To Aider" },
      { "<f16>ab", "<cmd>AiderQuickSendBuffer<cr>", desc = "Send Buffer To Aider" },
      { "<f16>a+", "<cmd>AiderQuickAddFile<cr>", desc = "Add File to Aider" },
      { "<f16>a-", "<cmd>AiderQuickDropFile<cr>", desc = "Drop File from Aider" },
      { "<f16>ar", "<cmd>AiderQuickReadOnlyFile<cr>", desc = "Add File as Read-Only" },
      -- Example nvim-tree.lua integration if needed
      { "<f16>aa", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "NvimTree" },
      { "<f16>ax", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "NvimTree" },
    },
    dependencies = {
      "folke/snacks.nvim",
      --- The below dependencies are optional
      "catppuccin/nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = true,
  },
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup()
    end,
    keys = {
      { "<localleader>cl", "<cmd>ClaudeCode<CR>", desc = "Claude Code" },
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
