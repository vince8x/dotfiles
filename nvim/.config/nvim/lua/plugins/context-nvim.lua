local M = {}

M.Generate_Code = [[ 
I need to implement [specific functionality] in [programming language].
Key requirements:
  1. [Requirement 1]
  2. [Requirement 2]
  3. [Requirement 3]
Please consider:
- Error handling
- Edge cases
- Performance optimization
- Best practices for [language/framework]
Please do not unnecessarily remove any comments or code.
Generate the code with clear comments explaining the logic. 
]]

M.Unit_Tests = [[
Generate unit tests for the following function:
[paste function]
  Include tests for:
  1. Normal expected inputs
  2. Edge cases
  3. Invalid inputs
Use [preferred testing framework] syntax.
]]

M.Explain = [[
Can you explain the following part of the code in detail:
[paste code section]
Specifically:
  1. What is the purpose of this section?
  2. How does it work step-by-step?
  3. Are there any potential issues or limitations with this approach?
]]

M.Code_Review = [[
Please review the following code:
[paste your code]
Consider:
1. Code quality and adherence to best practices
2. Potential bugs or edge cases
3. Performance optimizations
4. Readability and maintainability
5. Any security concerns
Suggest improvements and explain your reasoning for each suggestion.
]]

return {
  {
    "napisani/context-nvim",
    config = function()
      require("context_nvim").setup({
        cmp = {
          enable = true, -- whether to enable the nvim-cmp source for referencing contexts

          register_cmp_avante = true, -- whether to include the cmp source for avante input buffers.
          -- They need to be registered using an autocmd, so this is a separate config option
          manual_context_keyword = "@manual_context", -- keyword to use for manual context
          history_keyword = "@history_context", -- keyword to use for history context
          prompt_keyword = "@prompt", -- keyword to use for prompt context
        },
        telescope = {
          enable = true, -- whether to enable the telescope picker
        },
        prompts = {
          {
            name = "Unit tests", -- the name of the prompt (required)
            prompt = M.Unit_Tests, -- the prompt text (required)
            cmp = "unit_tests", -- an alternate name for the cmp completion source (optional) defaults to 'name'
          },
          {
            name = "Generate Code",
            prompt = M.Generate_Code,
            cmp = "gencode",
          },
          {
            name = "Explain Code",
            prompt = M.Explain,
            cmp = "explain",
          },
          {
            name = "Code Review",
            prompt = M.Code_Review,
            cmp = "review",
          },
        },
      })
    end,
    keys = {
      { "<localleader>af", "<cmd>ContextNvim add_current_file<cr>", desc = "Add current (f)ile" },
      { "<localleader>ac", "<cmd>ContextNvim add_current<cr>", desc = "Add (c)urrent" },
      { "<localleader>ad", "<cmd>ContextNvim add_dir<cr>", desc = "Add (d)ir" },
      { "<localleader>aq", "<cmd>ContextNvim add_qflist<cr>", desc = "Add (q)uickfix list" },
      { "<localleader>al", "<cmd>ContextNvim add_line_lsp_daig<cr>", desc = "Add line lsp diagnostic" },
      { "<localleader>cch", "<cmd>ContextNvim clear_history<cr>", desc = "Clear history" },
      { "<localleader>ccm", "<cmd>ContextNvim clear_manual<cr>", desc = "Clear manual" },
      { "<localleader>im", "<cmd>ContextNvim find_context_manual<cr>", desc = "Find context manual" },
      { "<localleader>ih", "<cmd>ContextNvim find_context_history<cr>", desc = "Find context history" },
      { "<localleader>ip", "<cmd>ContextNvim insert_prompt<cr>", desc = "Insert prompt" },
    },
  },
  {
    "YounesElhjouji/nvim-copy",
    lazy = false, -- disables lazy-loading so the plugin is loaded on startup
    config = function()
      -- Optional: additional configuration or key mappings
      vim.api.nvim_set_keymap("n", "<f16>cb", ":CopyBuffersToClipboard<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<f16>cc", ":CopyCurrentBufferToClipboard<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<f16>cg", ":CopyGitFilesToClipboard<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<f16>cq", ":CopyQuickfixFilesToClipboard<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<f16>ch", ":CopyHarpoonFilesToClipboard<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<f16>cd", ":CopyDirectoryFilesToClipboard<CR>", { noremap = true, silent = true })

      vim.keymap.set("n", "<f16>cd", function()
        vim.ui.input({
          prompt = "Enter directory path: ",
          default = vim.fn.getcwd(), -- Default to current working directory
        }, function(input)
          if input then -- Only proceed if input wasn't cancelled
            vim.cmd(string.format("CopyDirectoryFilesToClipboard %s norecurse", input))
          end
        end)
      end, { noremap = true, silent = true })
    end,
  },
}
