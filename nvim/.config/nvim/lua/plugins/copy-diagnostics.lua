return {
  "nvim-lua/plenary.nvim", -- Optional dependency if you want to use it
  keys = {
    {
      "<localleader>cd",
      function()
        local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
        if #diagnostics == 0 then
          vim.notify("No diagnostics at current line", vim.log.levels.WARN)
          return
        end

        local message = diagnostics[1].message
        -- Copy to both clipboard registers
        vim.fn.setreg('"', message) -- Default register
        vim.fn.setreg('+', message) -- System clipboard
        vim.fn.setreg('*', message) -- Selection clipboard
        
        vim.notify("Diagnostic copied: " .. message, vim.log.levels.INFO)
      end,
      desc = "Copy diagnostics to clipboard",
    },
  },
}

