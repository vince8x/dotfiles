return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
    "ravitemer/mcphub.nvim",
    "banjo/contextfiles.nvim",
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
                  ["meta-llama/llama-4-scout-17b-16e-instruct"] = "Llama 4 Scout 17B from Meta",
                  ["meta-llama/llama-4-maverick-17b-128e-instruct"] = "Llama 4 Maverick 17B from Meta",
                },
              },
            },
            max_tokens = {
              default = 32768,
            },
            temperature = {
              default = 0.2,
              top_p = 0.1,
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
                ["google/gemini-2.5-pro-exp-03-25"] = "Gemini 2.5 from Google",
                ["qwen/qwen2.5-vl-32b-instruct"] = "Qwen 2.5 from Qwen",
                ["qwen/qwq-32b"] = "Qwq 32b from Qwen",
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
                ["meta-llama/llama-4-scout"] = "Llama 4 Scout 17B from Meta",
                ["meta-llama/llama-4-maverick"] = "Llama 4 Maverick 17B from Meta",
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
      ["context"] = {
        strategy = "chat",
        description = "Chat with context files",
        opts = {
          -- ...
        },
        prompts = {
          {
            role = "user",
            opts = {
              contains_code = true,
            },
            content = function(context)
              local ctx = require("contextfiles.extensions.codecompanion")

              local ctx_opts = {
                -- ...
              }
              local format_opts = {
                -- ...
              }

              return ctx.get(context.filename, ctx_opts, format_opts)
            end,
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
}
