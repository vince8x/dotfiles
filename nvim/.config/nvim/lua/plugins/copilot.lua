return {
  {
    "github/copilot.vim",
    enabled = false,
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
        prompt_header = "Here are relevant files from the repository:", -- Customize header text
        prompt_footer = "\nConsider this context when answering:", -- Customize footer text
        skip_empty = true, -- Skip adding context when no files are retrieved
      })
      opts.contexts = vim.tbl_extend("force", opts.contexts or {}, { vectorcode = vectorcode_ctx })
      opts.prompts = vim.tbl_extend("force", opts.prompts or {}, {
        Explain = {
          prompt = "Explain the following code in detail:\n$input",
          context = { "selection", "vectorcode" }, -- Add vectorcode to the context
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
    "copilotlsp-nvim/copilot-lsp",
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot")
      vim.keymap.set("n", "<C-.>", function()
        require("copilot-lsp.nes").apply_pending_nes()
      end)
    end,
    disable = true,
  },
}
