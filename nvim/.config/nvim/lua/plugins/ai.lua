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
  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = "Aider",
    -- Example key mappings for common actions:
    keys = {
      { "<f16>a/", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
      { "<f16>as", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
      { "<f16>ac", "<cmd>Aider command<cr>", desc = "Aider Commands" },
      { "<f16>ab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
      { "<f16>a+", "<cmd>Aider add<cr>", desc = "Add File" },
      { "<f16>a-", "<cmd>Aider drop<cr>", desc = "Drop File" },
      { "<f16>ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
      { "<f16>aR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
      -- Example nvim-tree.lua integration if needed
      { "<f16>a+", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "neo-tree" },
      { "<f16>a-", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "neo-tree" },
    },
    dependencies = {
      "folke/snacks.nvim",
      --- The below dependencies are optional
      --- Neo-tree integration
      {
        "nvim-neo-tree/neo-tree.nvim",
        opts = function(_, opts)
          -- Example mapping configuration (already set by default)
          opts.window = {
            mappings = {
              ["+"] = { "nvim_aider_add", desc = "add to aider" },
              ["-"] = { "nvim_aider_drop", desc = "drop from aider" },
              ["="] = { "nvim_aider_add_read_only", desc = "add read-only to aider" },
            },
          }
          require("nvim_aider.neo_tree").setup(opts)
        end,
      },
    },
    config = true,
  },
  {
    "coder/claudecode.nvim",
    dependencies = {
      "folke/snacks.nvim", -- optional
    },
    config = true,
    keys = {
      { "<f16>l", nil, desc = "AI/Claude Code" },
      { "<f16>lc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<f16>lf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<f16>lr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<f16>lC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<f16>ls", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<f16>ls",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
    },
  },
  {
    "SouhailBlmn/claude-code.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
      "nvim-telescope/telescope.nvim", -- Optional, for terminal picker
    },
    config = function()
      require("claude-code").setup({
        size = 100,
        direction = "vertical",
      })
    end,
    keys = {
      { "<f16>lc", "<cmd>ClaudeCode<cr>", desc = "Toggle current terminal Claude Code" },
      { "<f16>ln", "<cmd>ClaudeCodeNew<cr>", desc = "New Claude Code" },
      { "<f16>ll", "<cmd>ClaudeCodeList<cr>", desc = "Claude Code picker" },
    },
  },
  {
    "johnseth97/codex.nvim",
    lazy = true,
    keys = {
      {
        "<localleader>cc",
        function()
          require("codex").toggle()
        end,
        desc = "Toggle Codex popup",
      },
    },
    opts = {
      keymaps = {}, -- disable internal mapping
      border = "rounded", -- or 'double'
      width = 0.8,
      height = 0.8,
      autoinstall = true,
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
        aliases = {
          translate = {
            system = "You are an interpretor. Translate any further text/user messages you receive to Spanish. If the text is a question, don't answer it, just translate the question to Spanish.",
            user_prefix = "",
            config = {
              model = "openai/gpt-4o-mini",
              temperature = 0.1,
            },
          },
          refactor = {
            system = "You are a coding expert. Refactor the provided code to improve readability, efficiency, and adherence to best practices. Explain your key improvements.",
            user_prefix = "Refactor the following code:",
          },
          test = {
            system = "You are a testing expert. Generate comprehensive unit tests for the provided code, focusing on edge cases and full coverage.",
            user_prefix = "Generate tests for:",
          },
          ["check-todo-list"] = {
            system = [[Your job is to evaluate a todo list and make sure everything is checked off.


Instructions:
- If everything is checked off, respond "Looks good!" and nothing else.
- Otherwise remind me what I still have to do.]],
            config = {
              expand_placeholders = true,
            },
            user_prefix = [[The todo is here:
        $FILE_CONTENTS
        ]],
          },
        },
      })
    end,
    keys = {
      { "<f16>ib", "<cmd>NAIBrowse<CR>", desc = "Nai Browse" },
    },
  },
  {
    "Davidyz/VectorCode",
    version = "*", -- optional, depending on whether you're on nightly or release
    build = "uv tool upgrade vectorcode", -- optional but recommended if you set `version = "*"`
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
    "NickvanDyke/opencode.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {
      -- Your configuration, if any
    },
    keys = {
      -- opencode.nvim exposes a general, flexible API — customize it to your workflow!
      -- But here are some examples to get you started :)
      {
        "<f16>ot",
        function()
          require("opencode").toggle()
        end,
        desc = "Toggle opencode",
      },
      {
        "<f16>oa",
        function()
          require("opencode").ask()
        end,
        desc = "Ask opencode",
        mode = { "n", "v" },
      },
      {
        "<f16>oA",
        function()
          require("opencode").ask("@file ")
        end,
        desc = "Ask opencode about current file",
        mode = { "n", "v" },
      },
      {
        "<f16>on",
        function()
          require("opencode").command("/new")
        end,
        desc = "New session",
      },
      {
        "<f16>oe",
        function()
          require("opencode").prompt("Explain @cursor and its context")
        end,
        desc = "Explain code near cursor",
      },
      {
        "<f16>or",
        function()
          require("opencode").prompt("Review @file for correctness and readability")
        end,
        desc = "Review file",
      },
      {
        "<f16>of",
        function()
          require("opencode").prompt("Fix these @diagnostics")
        end,
        desc = "Fix errors",
      },
      {
        "<f16>oo",
        function()
          require("opencode").prompt("Optimize @selection for performance and readability")
        end,
        desc = "Optimize selection",
        mode = "v",
      },
      {
        "<f16>od",
        function()
          require("opencode").prompt("Add documentation comments for @selection")
        end,
        desc = "Document selection",
        mode = "v",
      },
      {
        "<f16>ot",
        function()
          require("opencode").prompt("Add tests for @selection")
        end,
        desc = "Test selection",
        mode = "v",
      },
    },
  },
  {
    "cousine/opencode-context.nvim",
    opts = {
      tmux_target = nil, -- Manual override: "session:window.pane"
      auto_detect_pane = true, -- Auto-detect opencode pane in current window
    },
    keys = {
      { "<f16>os", "<cmd>OpencodeSend<cr>", desc = "Send prompt to opencode" },
      { "<f16>os", "<cmd>OpencodeSend<cr>", mode = "v", desc = "Send prompt to opencode" },
      { "<f16>ow", "<cmd>OpencodeSwitchMode<cr>", desc = "Toggle opencode mode" },
      { "<f16>op", "<cmd>OpencodePrompt<cr>", desc = "Open opencode persistent prompt" },
    },
    cmd = { "OpencodeSend", "OpencodeSwitchMode" },
  },
  {
    "piersolenski/wtf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim", -- Optional: For WtfGrepHistory
    },
    opts = {},
    keys = {
      {
        "<f16>wd",
        mode = { "n", "x" },
        function()
          require("wtf").diagnose()
        end,
        desc = "Debug diagnostic with AI",
      },
      {
        "<f16>wf",
        mode = { "n", "x" },
        function()
          require("wtf").fix()
        end,
        desc = "Fix diagnostic with AI",
      },
      {
        mode = { "n" },
        "<f16>ws",
        function()
          require("wtf").search()
        end,
        desc = "Search diagnostic with Google",
      },
      {
        mode = { "n" },
        "<f16>wp",
        function()
          require("wtf").pick_provider()
        end,
        desc = "Pick provider",
      },
      {
        mode = { "n" },
        "<f16>wh",
        function()
          require("wtf").history()
        end,
        desc = "Populate the quickfix list with previous chat history",
      },
      {
        mode = { "n" },
        "<f16>wg",
        function()
          require("wtf").grep_history()
        end,
        desc = "Grep previous chat history with Telescope",
      },
    },
  },
  {
    "skywind3000/vim-gpt-commit",
    config = function()
      -- if you don't want to set your api key directly, add to your .zshrc:
      -- export OPENAI_API_KEY='sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
      vim.g.gpt_commit_key = os.getenv("OPENAI_API_KEY")
      -- uncomment this line below to enable proxy
      -- vim.g.gpt_commit_proxy = 'socks5://127.0.0.1:1080'

      -- uncomment the following lines if you want to use Ollama:
      -- vim.g.gpt_commit_engine = 'ollama'
      -- vim.g.gpt_commit_ollama_url = 'http://127.0.0.1:11434/api/chat'
      -- vim.g.gpt_commit_ollama_model = 'llama2'
    end,
  },
  {
    "k2589/LLuMinate.nvim",
    config = function()
      require("lluminate").setup()
    end,
    keys = {
      { "<f16>lm", ":EnrichContext<CR>", mode = "n", desc = "Enrich Context" },
      { "<f16>lm", ":<C-u>EnrichContext<CR>", mode = "v", desc = "Enrich Context (Visual)" },
    },
  },
}
