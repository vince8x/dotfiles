return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  opts = {
    provider = "gemini",
    auto_suggestions_provider = "gemini",
    gemini = {
      endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
      model = "gemini-2.0-flash-exp",
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 4096,
      ["local"] = false,
    },
    vendors = {
      deepseek = {
        __inherited_from = "openai",
        api_key_name = "DEEPSEEK_API_KEY",
        endpoint = "https://api.deepseek.com/v1",
        model = "deepseek-chat",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
      },
      ["groq-r1"] = {
        __inherited_from = "openai",
        api_key_name = "GROQ_API_KEY",
        endpoint = "https://api.groq.com/openai/v1/chat/completions",
        model = "deepseek-r1-distill-llama-70b",
      },
      ["openrouter-qwen"] = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "qwen/qwen-2.5-coder-32b-instruct",
      },
    },
    dual_boost = {
      enabled = false,
      first_provider = "gemini",
      second_provider = "deepseek",
      prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
      timeout = 60000, -- Timeout in milliseconds
    },
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
  keys = {
    {
      "<leader>am",
      function()
        local function AvanteSwitchProvider()
          local providers = { "deepseek", "openrouter-qwen", "gemini"}
          vim.ui.select(providers, {
            prompt = "Select Avante Provider:",
            format_item = function(item)
              return item
            end,
          }, function(choice)
            if choice then
              vim.cmd("AvanteSwitchProvider " .. choice)
              vim.notify("Avante provider switched to " .. choice, vim.log.levels.INFO)
            end
          end)
        end
        AvanteSwitchProvider()
      end,
      desc = "Switch Avante Provider",
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
  },
}
