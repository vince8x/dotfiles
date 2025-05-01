local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local codecompanion_group = augroup("CodeCompanionAutoSave", { clear = true })

local function save_codecompanion_buffer(bufnr)
  local data_path = vim.fn.stdpath("data")
  local save_dir = vim.fn.stdpath("data") .. "/codecompanion"

  vim.fn.mkdir(save_dir, "p")

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)

  -- Extract the unique ID from the buffer name
  local id = bufname:match("%[CodeCompanion%] (%d+)")
  local date = os.date("%Y-%m-%d")
  local save_path

  if id then
    -- Use date plus ID to ensure uniqueness
    save_path = save_dir .. "/" .. date .. "_codecompanion_" .. id .. ".md"
  else
    -- Fallback with timestamp to ensure uniqueness if no ID
    save_path = save_dir .. "/" .. date .. "_codecompanion_" .. os.date("%H%M%S") .. ".md"
  end

  -- Write buffer content to file
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local file = io.open(save_path, "w")
  if file then
    file:write(table.concat(lines, "\n"))
    file:close()
  end
end

autocmd({ "InsertLeave", "TextChanged", "BufLeave", "FocusLost" }, {
  group = codecompanion_group,
  callback = function(args)
    local bufnr = args.buf
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if bufname:match("%[CodeCompanion%]") then
      save_codecompanion_buffer(bufnr)
    end
  end,
})

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "j-hui/fidget.nvim",
    "echasnovski/mini.diff",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
    { "Davidyz/VectorCode", cmd = "VectorCode" },
    "ravitemer/mcphub.nvim",
    "banjo/contextfiles.nvim",
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)
  end,
  opts = {
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
              ["google/gemini-2.5-flash-preview-04-17"] = "Gemini Flash 2.5 from Google",
              ["anthropic/claude-3.5-sonnet"] = "Claude 3.5 from Anthropic",
              ["anthropic/claude-3.7-sonnet"] = "Claude 3.7 from Anthropic",
              ["deepseek/deekseek-chat-v3-0324"] = "Deepseek Chat v3 from Deepseek",
              ["google/gemini-2.5-pro-exp-03-25"] = "Gemini 2.5 from Google",
              ["qwen/qwen3-30b-a3b"] = "qwen3-30b-a3b",
              ["qwen/qwen3-235b-a22b"] = "qwen3-235b-a22b",
            },
          },
        })
      end,
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          schema = {
            model = {
              default = "gemini-2.5-flash-preview-04-17",
            },
            choices = {
              ["gemini-2.5-flash-preview-04-17"] = "Gemini Flash 2.5 from Google",
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
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          schema = {
            model = {
              default = "o4-mini",
            },
          },
        })
      end,
    },
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
    },
    strategies = {
      chat = {
        adapter = vim.g.codecompanion_initial_adapter,
        roles = {
          user = vim.env.USERNAME,
          llm = function(adapter)
            if not (adapter and adapter.schema and adapter.schema.model) then
              return "CodeCompanion"
            end

            return "CodeCompanion (" .. adapter.formatted_name .. ":" .. adapter.schema.model.default .. ")"
          end,
        },
        keymaps = {
          send = {
            modes = { i = "<S-CR>", n = "<CR>" },
          },
          clear = {
            modes = {
              i = "<C-l>",
              n = "<C-l>",
            },
          },
          close = {
            modes = { n = {}, i = {} },
          },
          stop = {
            modes = { n = "<C-c>", i = "<C-c>" },
          },
        },
        slash_commands = {
          ["buffer"] = {
            opts = {
              provider = "snacks",
              keymaps = {
                modes = {
                  i = "<C-b>",
                },
              },
            },
          },
          ["help"] = {
            opts = {
              provider = "snacks",
              max_lines = 1000,
            },
          },
          ["file"] = {
            opts = {
              provider = "snacks",
            },
          },
          ["symbols"] = {
            opts = {
              provider = "snacks",
            },
          },
          codebase = require("vectorcode.integrations").codecompanion.chat.make_slash_command(),
        },
        tools = {
          vectorcode = {
            description = "Run VectorCode to retrieve the project context.",
            callback = function()
              return require("vectorcode.integrations").codecompanion.chat.make_tool()
            end,
          },
        },
      },
      inline = { adapter = "deepseek" },
      agent = { adapter = "deepseek" },
    },
    display = {
      action_palette = {
        provider = "default",
        opts = {
          show_default_actions = true,
          show_default_prompt_library = true,
        },
      },
      chat = {
        intro_message = "",
        show_references = true,
        show_header_separator = true,
        show_settings = false,
        render_headers = false,
        start_in_insert_mode = false,
      },
      diff = {
        provider = "mini_diff",
      },
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
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionActions",
    "CodeCompanionChat",
  },
  init = function()
    require("plugins.codecompanion.fidget-spinner"):init()
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccc CodeCompanionChat]])
    vim.cmd([[cab cca CodeCompanionActions]])
  end,
  keys = {
    {
      "<leader>ai",
      "<cmd>CodeCompanionChat Toggle<cr>",
      desc = "Toggle (CopilotChatToggle)",
      mode = { "n", "v", "i" },
    },
    {
      "<localleader>Cc>",
      function()
        if vim.bo.ft == "codecompanion" then
          if Snacks.zen.win and Snacks.zen.win:valid() then
            Snacks.zen.zoom()
          end

          vim.cmd("CodeCompanionChat Toggle")
          return
        end

        vim.cmd("CodeCompanionChat")
        Snacks.zen.zoom()
      end,
      desc = "Open Code Companion Chat Zoomed In",
      mode = { "n", "v", "i" },
    },
    {
      "<localleader>Cf",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("data") .. "/codecompanion" })
      end,
      desc = "Find Previous Chats",
    },
  },
}
