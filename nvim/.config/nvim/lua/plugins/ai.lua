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
      vim.keymap.set("i", "<c-e>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-n>", function()
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
    opts = {
      -- auto_manage_context = false,
      default_bindings = false,
    },
    keys = function()
      return {

        {
          "<leader>ao",
          desc = "Aider",
        },
        {
          "<leader>aoa",
          "<cmd>lua AiderOpen()<cr>i",
          desc = "Aider Open",
        },
        {
          "<leader>aob",
          "<cmd>lua AiderBackground()<cr>",
          desc = "Aider Background",
          -- defaults to message "Complete as many todo items as you can and remove the comment for any item you complete."
        },
      }
    end,
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
        providers = {
          openai = {
            endpoint = "https://api.openai.com/v1/chat/completions",
            secret = os.getenv("OPENAI_API_KEY"),
          },

          -- azure = {...},

          copilot = {
            endpoint = "https://api.githubcopilot.com/chat/completions",
            secret = {
              "bash",
              "-c",
              "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
            },
          },

          pplx = {
            endpoint = "https://api.perplexity.ai/chat/completions",
            secret = os.getenv("PPLX_API_KEY"),
          },

          ollama = {
            endpoint = "http://localhost:11434/v1/chat/completions",
          },

          googleai = {
            endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
            secret = os.getenv("GOOGLEAI_API_KEY"),
          },

          anthropic = {
            endpoint = "https://api.anthropic.com/v1/messages",
            secret = os.getenv("ANTHROPIC_API_KEY"),
          },
        },

        agents = {
          -- Remove default agents
          { name = "CodeGPT3-5", disabled = true },
          {
            name = "ChatGPT4",
            chat = true,
            command = false,
            model = { model = "gpt-4o-mini", temperature = 0.2, top_p = 0.1 },
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
            chat = true,
            command = true,
            model = { model = "gpt-4o-mini", temperature = 0.2, top_p = 0.1 },
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

      require("which-key").add({
        -- VISUAL mode mappings
        -- s, x, v modes are handled the same way by which_key
        {
          mode = { "v" },
          nowait = true,
          remap = false,
          { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "ChatNew tabnew" },
          { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "ChatNew vsplit" },
          { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", desc = "ChatNew split" },
          { "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", desc = "Visual Append (after)" },
          { "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", desc = "Visual Prepend (before)" },
          { "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", desc = "Visual Chat New" },
          { "<C-g>g", group = "generate into new .." },
          { "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", desc = "Visual GpEnew" },
          { "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", desc = "Visual GpNew" },
          { "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", desc = "Visual Popup" },
          { "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", desc = "Visual GpTabnew" },
          { "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", desc = "Visual GpVnew" },
          { "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", desc = "Implement selection" },
          { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
          { "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Visual Chat Paste" },
          { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite" },
          { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
          { "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", desc = "Visual Toggle Chat" },
          { "<C-g>w", group = "Whisper" },
          { "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>", desc = "Whisper Append" },
          { "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>", desc = "Whisper Prepend" },
          { "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", desc = "Whisper Enew" },
          { "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", desc = "Whisper New" },
          { "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", desc = "Whisper Popup" },
          { "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", desc = "Whisper Rewrite" },
          { "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
          { "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
          { "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", desc = "Whisper" },
          { "<C-g>x", ":<C-u>'<,'>GpContext<cr>", desc = "Visual GpContext" },
        },

        -- NORMAL mode mappings
        {
          mode = { "n" },
          nowait = true,
          remap = false,
          { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
          { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
          { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
          { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
          { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
          { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
          { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
          { "<C-g>g", group = "generate into new .." },
          { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
          { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
          { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
          { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
          { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
          { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
          { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
          { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
          { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
          { "<C-g>w", group = "Whisper" },
          { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" },
          { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" },
          { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
          { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
          { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
          { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" },
          { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
          { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
          { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
          { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
        },

        -- INSERT mode mappings
        {
          mode = { "i" },
          nowait = true,
          remap = false,
          { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
          { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
          { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
          { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
          { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
          { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
          { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
          { "<C-g>g", group = "generate into new .." },
          { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
          { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
          { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
          { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
          { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
          { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
          { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
          { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
          { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
          { "<C-g>w", group = "Whisper" },
          { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" },
          { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" },
          { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
          { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
          { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
          { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" },
          { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
          { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
          { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
          { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
        },
      })
    end,
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
