return {
  "jonatan-branting/nvim-better-n",
  config = function()
    require("better-n").setup({
      -- These are default values, which can be omitted.
      -- By default, the following mappings are made repeatable using `n` and `<S-n>`:
      -- `f`, `F`, `t`, `T`, `*`, `#`, `/`, `?`
      disable_default_mappings = false,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "BetterNMappingExecuted",
      callback = function(args)
        -- args.data.key and args.data.mode are available here
      end,
    })

    local better = require("better-n")
    -- You create repeatable mappings like this:
    local diagnostic_navigation = better.create({
      next = vim.diagnostic.goto_next,
      previous = vim.diagnostic.goto_prev,
    })

    local hunk_navigation = require("better-n").create({
      next = require("gitsigns").next_hunk,
      previous = require("gitsigns").prev_hunk,
    })

    vim.keymap.set({ "n", "x" }, "]d", diagnostic_navigation.next)
    vim.keymap.set({ "n", "x" }, "[d", diagnostic_navigation.previous)

    vim.keymap.set({ "n", "x" }, "]h", hunk_navigation.next)
    vim.keymap.set({ "n", "x" }, "[h", hunk_navigation.previous)
  end,
}
