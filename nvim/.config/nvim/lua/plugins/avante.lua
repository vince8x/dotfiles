return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  opts = {
    provider = "gemini",
    auto_suggestions_provider = "gemini",
    gemini = {
      endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
      model = "gemini-2.5-pro-exp-03-25",
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
      groq = {
        __inherited_from = "openai",
        api_key_name = "GROQ_API_KEY",
        endpoint = "https://api.groq.com/openai/v1/",
        -- model = 'llama-3.2-90b-text-preview',
        -- model = 'llama-3.3-70b-specdec',
        model = "meta-llama/llama-4-scout-17b-16e-instruct",
      },
      cerebras = {
        __inherited_from = "openai",
        api_key_name = "CEREBRAS_API_KEY",
        endpoint = "https://api.cerebras.ai/v1/",
        model = "llama3.1-70b",
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
      ["openrouter-llama-4-scout"] = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "meta-llama/llama-4-maverick",
      },
      ["quasar-alpha"] = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "openrouter/quasar-alpha",
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
    system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      return hub:get_active_servers_prompt()
    end,
    disable_tools = { "fetch" },
    custom_tools = function()
      return {
        require("mcphub.extensions.avante").mcp_tool(),
        {
          name = "run_pytest",
          description = "Run python unittest and return results",
          param = {
            type = "table",
            fields = {
              {
                name = "manager",
                description = "The python package manager to use, e.g. 'uv', 'poetry'. Read the ./pyproject.toml to set it.",
                type = "string",
                optional = false,
              },
              {
                name = "target",
                description = "The testcase to run, should be the a relative path of file in ./tests",
                type = "string",
                optional = true,
              },
            },
          },
          returns = {
            {
              name = "result",
              description = "Result of the fetch",
              type = "string",
            },
            {
              name = "error",
              description = "Error message if the fetch was not successful",
              type = "string",
              optional = true,
            },
          },
          func = function(params, on_log, on_complete)
            local manager = params.manager
            if manager ~= "uv" and manager ~= "poetry" then
              return nil, string.format("Invalid package manager '%s'. Only 'uv' or 'poetry' are supported.", manager)
            end
            local target = params.target or ""
            local cmd = string.format("%s run pytest %s", manager, target)
            return vim.fn.system(cmd)
          end,
        },
        {
          name = "load_workflow",
          description = "When the user input contains a format '!{workflow_name}', and the workflow_file exist in one of ['workflows/{workflow_name}.md', '~/.config/nvim/workflows/{workflow_name}.md'], then trigger the workflow.",
          param = {
            type = "table",
            fields = {
              {
                name = "workflow_name",
                description = "The workflow name to load",
                type = "string",
                optional = false,
              },
            },
          },
          returns = {
            {
              name = "result",
              description = "The workflow content, You should do what the workflow says.",
              type = "string",
            },
            {
              name = "error",
              description = "Error message if the workflow file read failed",
              type = "string",
              optional = true,
            },
          },
          func = function(params, on_log, on_complete)
            local workflow_name = params.workflow_name
            on_log("Starting to load workflow: " .. workflow_name)

            -- Sanitize workflow name
            -- Remove any directory traversal attempts and special characters
            -- Only allow alphanumeric characters, hyphens, and underscores
            local sanitized_name = workflow_name:gsub("[^%w%-_]", "")

            -- Check if the name was modified during sanitization
            if sanitized_name ~= workflow_name then
              local error_msg = string.format(
                "Invalid workflow name '%s'. Only alphanumeric characters, hyphens, and underscores are allowed.",
                workflow_name
              )
              on_log("Error: " .. error_msg)
              return nil, error_msg
            end

            -- Check for empty name after sanitization
            if sanitized_name == "" then
              on_log("Error: Workflow name cannot be empty")
              return nil, "Workflow name cannot be empty"
            end

            -- Define possible workflow file paths
            local paths = {
              string.format("workflows/%s.md", sanitized_name),
              string.format("%s/.config/nvim/workflows/%s.md", os.getenv("HOME"), sanitized_name),
            }

            -- Try to read from either path
            for _, path in ipairs(paths) do
              on_log("Trying to read from: " .. path)
              local file = io.open(path, "r")
              if file then
                local content = file:read("*all")
                file:close()
                on_log("Successfully loaded workflow from: " .. path)
                return content
              end
            end

            -- If no file was found, return an error
            local error_msg =
              string.format("Workflow '%s' not found in either workflows/ or ~/.config/nvim/workflows/", sanitized_name)
            on_log("Error: " .. error_msg)
            return nil, error_msg
          end,
        },
      }
    end,
  },
  keys = {
    {
      "<leader>am",
      function()
        local function AvanteSwitchProvider()
          local providers = { "deepseek", "openrouter-qwen", "gemini" }
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
    "ravitemer/mcphub.nvim",
  },
}
