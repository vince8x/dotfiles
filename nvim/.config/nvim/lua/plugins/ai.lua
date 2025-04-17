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
            user_message = "<Leader>iu",
            scrape = "<f16>id",
            web = "<f16>iw",
            youtube = "<f16>iy",
            reference = "<f16>ir",
            snapshot = "<f16>is",
            crawl = "<f16>il",
          },
          settings = {
            select_model = "<Leader>am",
            toggle_provider = "<Leader>ap",
          },
        },
      })
    end,
  },
}
