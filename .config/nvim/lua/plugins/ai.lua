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
      vim.keymap.set("i", "<c-;>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-,>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
    end,
  },
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
    "joshuavial/aider.nvim",
    event = "VeryLazy",
    dependencies = {
      "folke/which-key.nvim",
    },
    config = function()
      require("aider").setup({
        auto_manage_context = true,
        default_bindings = false,
      })
    end,
    keys = {
      {
        "<leader>ao",
        desc = "Aider",
      },
      {
        "<leader>aoa",
        function()
          require("aider").AiderOpen()
        end,
        desc = "Aider Open",
      },
      {
        "<leader>aob",
        function()
          require("aider").AiderBackground()
        end,
        desc = "Aider Background",
      },
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
        api_key_cmd = "pass show apikey/openai",
        keymaps = {
          submit = "<C-j>",
          yank_last_code = "<C-y>",
        },
      })
      require("which-key").register({
        ["<leader>o"] = {
          name = "OpenAI's ChatGPT",
          c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
          e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
          g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
          t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
          k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
          d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
          a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
          o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
          s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
          f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
          x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
          r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
          l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
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
    "robitx/gp.nvim",
    config = function()
      require("gp").setup({
        agents = {
          -- Remove default agents
          { name = "ChatGPT3-5" },
          { name = "CodeGPT3-5" },

          {
            name = "ChatGPT4",
            chat = true,
            command = false,
            model = { model = "gpt-4o", temperature = 0.2, top_p = 0.1 },
            system_prompt = "You are a general AI assistant.\n\n"
              .. "The user provided the additional info about how they would like you to respond:\n\n"
              .. "- If you're unsure don't guess and say you don't know instead.\n"
              .. "- Ask question if you need clarification to provide better answer.\n"
              .. "- Think deeply and carefully from first principles step by step.\n"
              .. "- Zoom out first to see the big picture and then zoom in to details.\n"
              .. "- Use Socratic method to improve your thinking and coding skills.\n"
              .. "- Don't elide any code from your output if the answer requires coding.\n"
              .. "- Take a deep breath; You've got this!\n",
          },
          {
            name = "CodeGPT4",
            chat = false,
            command = true,
            model = { model = "gpt-4o", temperature = 0.2, top_p = 0.1 },
            system_prompt = "You are an AI working as a code editor.\n\n"
              .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
              .. "START AND END YOUR ANSWER WITH:\n\n```",
          },
        },
        hooks = {
          Implement = function(gp, params)
            local template = "Having following from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Please rewrite this according to the contained instructions."
              .. "\n\nRespond exclusively with the snippet that should replace the selection above."
            local agent = gp.get_command_agent()
            gp.Prompt(params, gp.Target.rewrite, nil, agent.model, template, agent.system_prompt)
          end,
          UnitTests = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Please respond by writing table driven unit tests for the code above."
            local agent = gp.get_command_agent()
            gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
          end,
          Explain = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Please respond by explaining the code above."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
          end,
        },
      })

      require("which-key").register({
        -- ...
        ["<C-g>"] = {
          c = { ":<C-u>'<,'>GpChatNew<cr>", "Visual Chat New" },
          p = { ":<C-u>'<,'>GpChatPaste<cr>", "Visual Chat Paste" },
          t = { ":<C-u>'<,'>GpChatToggle<cr>", "Visual Toggle Chat" },

          ["<C-x>"] = { ":<C-u>'<,'>GpChatNew split<cr>", "Visual Chat New split" },
          ["<C-v>"] = { ":<C-u>'<,'>GpChatNew vsplit<cr>", "Visual Chat New vsplit" },
          ["<C-t>"] = { ":<C-u>'<,'>GpChatNew tabnew<cr>", "Visual Chat New tabnew" },

          r = { ":<C-u>'<,'>GpRewrite<cr>", "Visual Rewrite" },
          a = { ":<C-u>'<,'>GpAppend<cr>", "Visual Append (after)" },
          b = { ":<C-u>'<,'>GpPrepend<cr>", "Visual Prepend (before)" },
          i = { ":<C-u>'<,'>GpImplement<cr>", "Implement selection" },

          g = {
            name = "generate into new ..",
            p = { ":<C-u>'<,'>GpPopup<cr>", "Visual Popup" },
            e = { ":<C-u>'<,'>GpEnew<cr>", "Visual GpEnew" },
            n = { ":<C-u>'<,'>GpNew<cr>", "Visual GpNew" },
            v = { ":<C-u>'<,'>GpVnew<cr>", "Visual GpVnew" },
            t = { ":<C-u>'<,'>GpTabnew<cr>", "Visual GpTabnew" },
          },

          n = { "<cmd>GpNextAgent<cr>", "Next Agent" },
          s = { "<cmd>GpStop<cr>", "GpStop" },
          x = { ":<C-u>'<,'>GpContext<cr>", "Visual GpContext" },

          w = {
            name = "Whisper",
            w = { ":<C-u>'<,'>GpWhisper<cr>", "Whisper" },
            r = { ":<C-u>'<,'>GpWhisperRewrite<cr>", "Whisper Rewrite" },
            a = { ":<C-u>'<,'>GpWhisperAppend<cr>", "Whisper Append (after)" },
            b = { ":<C-u>'<,'>GpWhisperPrepend<cr>", "Whisper Prepend (before)" },
            p = { ":<C-u>'<,'>GpWhisperPopup<cr>", "Whisper Popup" },
            e = { ":<C-u>'<,'>GpWhisperEnew<cr>", "Whisper Enew" },
            n = { ":<C-u>'<,'>GpWhisperNew<cr>", "Whisper New" },
            v = { ":<C-u>'<,'>GpWhisperVnew<cr>", "Whisper Vnew" },
            t = { ":<C-u>'<,'>GpWhisperTabnew<cr>", "Whisper Tabnew" },
          },
        },
        -- ...
      }, {
        mode = "v", -- VISUAL mode
        prefix = "",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = true,
      })

      -- NORMAL mode mappings
      require("which-key").register({
        -- ...
        ["<C-g>"] = {
          c = { "<cmd>GpChatNew<cr>", "New Chat" },
          t = { "<cmd>GpChatToggle<cr>", "Toggle Chat" },
          f = { "<cmd>GpChatFinder<cr>", "Chat Finder" },

          ["<C-x>"] = { "<cmd>GpChatNew split<cr>", "New Chat split" },
          ["<C-v>"] = { "<cmd>GpChatNew vsplit<cr>", "New Chat vsplit" },
          ["<C-t>"] = { "<cmd>GpChatNew tabnew<cr>", "New Chat tabnew" },

          r = { "<cmd>GpRewrite<cr>", "Inline Rewrite" },
          a = { "<cmd>GpAppend<cr>", "Append (after)" },
          b = { "<cmd>GpPrepend<cr>", "Prepend (before)" },

          g = {
            name = "generate into new ..",
            p = { "<cmd>GpPopup<cr>", "Popup" },
            e = { "<cmd>GpEnew<cr>", "GpEnew" },
            n = { "<cmd>GpNew<cr>", "GpNew" },
            v = { "<cmd>GpVnew<cr>", "GpVnew" },
            t = { "<cmd>GpTabnew<cr>", "GpTabnew" },
          },

          n = { "<cmd>GpNextAgent<cr>", "Next Agent" },
          s = { "<cmd>GpStop<cr>", "GpStop" },
          x = { "<cmd>GpContext<cr>", "Toggle GpContext" },

          w = {
            name = "Whisper",
            w = { "<cmd>GpWhisper<cr>", "Whisper" },
            r = { "<cmd>GpWhisperRewrite<cr>", "Whisper Inline Rewrite" },
            a = { "<cmd>GpWhisperAppend<cr>", "Whisper Append (after)" },
            b = { "<cmd>GpWhisperPrepend<cr>", "Whisper Prepend (before)" },
            p = { "<cmd>GpWhisperPopup<cr>", "Whisper Popup" },
            e = { "<cmd>GpWhisperEnew<cr>", "Whisper Enew" },
            n = { "<cmd>GpWhisperNew<cr>", "Whisper New" },
            v = { "<cmd>GpWhisperVnew<cr>", "Whisper Vnew" },
            t = { "<cmd>GpWhisperTabnew<cr>", "Whisper Tabnew" },
          },
        },
        -- ...
      }, {
        mode = "n", -- NORMAL mode
        prefix = "",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = true,
      })

      -- INSERT mode mappings
      require("which-key").register({
        -- ...
        ["<C-g>"] = {
          c = { "<cmd>GpChatNew<cr>", "New Chat" },
          t = { "<cmd>GpChatToggle<cr>", "Toggle Chat" },
          f = { "<cmd>GpChatFinder<cr>", "Chat Finder" },

          ["<C-x>"] = { "<cmd>GpChatNew split<cr>", "New Chat split" },
          ["<C-v>"] = { "<cmd>GpChatNew vsplit<cr>", "New Chat vsplit" },
          ["<C-t>"] = { "<cmd>GpChatNew tabnew<cr>", "New Chat tabnew" },

          r = { "<cmd>GpRewrite<cr>", "Inline Rewrite" },
          a = { "<cmd>GpAppend<cr>", "Append (after)" },
          b = { "<cmd>GpPrepend<cr>", "Prepend (before)" },

          g = {
            name = "generate into new ..",
            p = { "<cmd>GpPopup<cr>", "Popup" },
            e = { "<cmd>GpEnew<cr>", "GpEnew" },
            n = { "<cmd>GpNew<cr>", "GpNew" },
            v = { "<cmd>GpVnew<cr>", "GpVnew" },
            t = { "<cmd>GpTabnew<cr>", "GpTabnew" },
          },

          x = { "<cmd>GpContext<cr>", "Toggle GpContext" },
          s = { "<cmd>GpStop<cr>", "GpStop" },
          n = { "<cmd>GpNextAgent<cr>", "Next Agent" },

          w = {
            name = "Whisper",
            w = { "<cmd>GpWhisper<cr>", "Whisper" },
            r = { "<cmd>GpWhisperRewrite<cr>", "Whisper Inline Rewrite" },
            a = { "<cmd>GpWhisperAppend<cr>", "Whisper Append (after)" },
            b = { "<cmd>GpWhisperPrepend<cr>", "Whisper Prepend (before)" },
            p = { "<cmd>GpWhisperPopup<cr>", "Whisper Popup" },
            e = { "<cmd>GpWhisperEnew<cr>", "Whisper Enew" },
            n = { "<cmd>GpWhisperNew<cr>", "Whisper New" },
            v = { "<cmd>GpWhisperVnew<cr>", "Whisper Vnew" },
            t = { "<cmd>GpWhisperTabnew<cr>", "Whisper Tabnew" },
          },
        },
        -- ...
      }, {
        mode = "i", -- INSERT mode
        prefix = "",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = true,
      })
    end,
  },
}
