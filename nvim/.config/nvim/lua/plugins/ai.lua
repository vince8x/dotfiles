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
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
      }
    end,
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      local vectorcode_ctx = require("vectorcode.integrations.copilotchat").make_context_provider({
        prompt_header = "Here are relevant files from the repository:",
        prompt_footer = "\nConsider this context when answering:",
        skip_empty = true,
      })
      opts.contexts = vim.tbl_extend("force", opts.contexts or {}, { vectorcode = vectorcode_ctx })
      opts.prompts = vim.tbl_extend("force", opts.prompts or {}, {
        DeepExplain = {
          prompt = "Please explain how the following code works.",
          context = { "selection", "vectorcode" },
        },
      })
      local chat = require("CopilotChat")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },
  {
    "github/copilot.vim",
    enabled = true,
  },
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
  {
    "azorng/goose.nvim",
    branch = "main",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
        },
      },
    },
    config = function()
      require("goose").setup({
        keymap = {
          global = {
            open_input = "<leader>gi", -- Opens and focuses on input window. Loads current buffer context
            open_input_new_session = "<leader>gI", -- Opens and focuses on input window. Loads current buffer context. Creates a new session
            open_output = "<leader>go", -- Opens and focuses on output window. Loads current buffer context
            close = "<leader>gq", -- Close UI windows
            toggle_fullscreen = "<leader>gf", -- Toggle between normal and fullscreen mode
            select_session = "<leader>gE", -- Select and load a goose session
          },
          window = {
            submit = "<cr>", -- Submit prompt
            close = "<esc>", -- Close UI windows
            stop = "<C-c>", -- Stop a running job
            next_message = "]]", -- Navigate to next message in the conversation
            prev_message = "[[", -- Navigate to previous message in the conversation
            mention_file = "@", -- Pick a file and add to context
          },
        },
        ui = {
          window_width = 0.35, -- Width as percentage of editor width
          input_height = 0.15, -- Input height as percentage of window height
          fullscreen = false, -- Start in fullscreen mode (default: false)
        },
      })
    end,
  },
  {
    "nathanbraun/nvim-ai",
    dependencies = { "nvim-telescope/telescope.nvim" },
    -- Optional, for model selection },
    config = function()
      require("nai").setup({
        mappings = {
          enabled = true,
          intercept_ctrl_c = true,
          chat = {
            continue = "<f16>ic",
            new = "<f16>ii",
            cancel = "<f16>ix",
          },
          expand = {
            blocks = "<f16>ie",
          },
          insert = {
            user_message = "<f16>iu",
            scrape = "<f16>id",
            web = "<f16>iw",
            youtube = "<f16>iy",
            reference = "<f16>ir",
            snapshot = "<f16>is",
            crawl = "<f16>il",
          },
          settings = {
            select_model = "<f16>im",
            toggle_provider = "<f16>ip",
          },
        },
      })
    end,
  },
  {
    "Davidyz/VectorCode",
    version = "*", -- optional, depending on whether you're on nightly or release
    build = "pipx upgrade vectorcode", -- optional but recommended if you set `version = "*"`
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(_, opts)
      local function check_chroma_server()
        local curl_cmd = 'curl -s -o /dev/null -w "%{http_code}" http://localhost:11434/api/v1/heartbeat'
        local status_code = tonumber(vim.fn.system(curl_cmd))

        if status_code and status_code >= 200 and status_code < 300 then
          vim.notify("Chroma DB server found on localhost:11434", vim.log.levels.INFO)
          return "localhost", "11434"
        end

        vim.notify("No Chroma DB server found", vim.log.levels.WARN)
        return nil, nil
      end

      local function update_config_file(host, port)
        if not (host and port) then
          return
        end

        local path = require("plenary.path")

        -- Use current working directory
        local cwd = vim.fn.getcwd()
        local config_dir = path:new(cwd, ".vectorcode")
        local config_file = config_dir:joinpath("config.json")

        -- Create directory if it doesn't exist
        if not config_dir:exists() then
          vim.fn.mkdir(config_dir.filename, "p")
        end

        -- Read existing config if it exists
        local config = {}
        local needs_update = true

        if config_file:exists() then
          local content = config_file:read()
          local ok, existing_config = pcall(vim.json.decode, content)
          if ok then
            config = existing_config
            -- Check if values are already set to the same values
            if config.host == host and config.port == port then
              needs_update = false
            end
          end
        end

        -- Only update if the values have changed or don't exist
        if needs_update then
          -- Update config with new host and port
          config.host = host
          config.port = port

          -- Write the updated config back to file
          local json_str = vim.json.encode(config)
          config_file:write(json_str, "w")
          vim.notify("Updated " .. config_file.filename .. " with server details", vim.log.levels.INFO)
        end
      end

      -- Check for Chroma server and update config file if found
      local host, port = check_chroma_server()
      if host and port then
        update_config_file(host, port)
      end

      local vectorcode = require("vectorcode")
      vectorcode.setup(opts)
    end,
  },
  {
    "Xuyuanp/nes.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
    -- lazy config
    config = function()
      vim.api.nvim_set_hl(0, "NesAdd", { link = "DiffAdd" })
      vim.api.nvim_set_hl(0, "NesDelete", { link = "DiffDelete" })
    end,
    keys = {
      {
        "<T-.>",
        function()
          require("nes").get_suggestion()
        end,
        mode = "i",
        desc = "[Nes] get suggestion",
      },
      {
        "<T-n>",
        function()
          require("nes").apply_suggestion(0, { jump = true, trigger = true })
        end,
        mode = "i",
        desc = "[Nes] apply suggestion",
      },
    },
  },
}
