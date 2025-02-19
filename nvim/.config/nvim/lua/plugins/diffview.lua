return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  opts = {
    file_panel = {
      position = "bottom",
      height = 20,
    },
    hooks = {
      diff_buf_win_enter = function(bufnr, winid, ctx)
        if ctx.layout_name:match("^diff2") then
          if ctx.symbol == "a" then
            vim.opt_local.winhl = table.concat({
              "DiffAdd:DiffviewDiffAddAsDelete",
              "DiffDelete:DiffviewDiffDelete",
            }, ",")
          elseif ctx.symbol == "b" then
            vim.opt_local.winhl = table.concat({
              "DiffDelete:DiffviewDiffDelete",
            }, ",")
          end
        end
      end,
    },
  },
  keys = {
    { "<leader>gd", "", desc = "+Diffview", mode = { "n", "v" } },
    { "<f16>", "", desc = "+Diffview", mode = { "n", "v" } },
    { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen" },
    { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },
    { "<leader>gdl", "<Cmd>.DiffviewFileHistory --follow<CR>", desc = "Line history", mode = "n" },
    { "<leader>gdr", "<cmd>DiffviewRefresh<cr>", desc = "DiffviewRefresh" },
    { "<leader>gdi", "<cmd>DiffviewFileHistory<cr>", desc = "DiffviewHistory" },
    { "<leader>gdh", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "DiffviewFileHistory" },
    { "<leader>gdv", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", desc = "Range history", mode = "v" },
    { "<leader>gdf", "<cmd>DiffviewFileFocusFiles<cr>", desc = "DiffviewFileFocusFiles" },
    { "<leader>gdm", "<cmd>:DiffviewOpen origin/master... --imply-local<cr>", desc = "Do review with master branch" },
    { "<leader>gd1", "<cmd>:DiffviewOpen HEAD^1... --imply-local<cr>", desc = "Do review with master branch" },
    { "<f16>gd1", "<cmd>:DiffviewOpen HEAD^1... --imply-local<cr>", desc = "Do review with master branch" },
    {
      "<leader>gdb",
      function()
        local branches = vim.fn.systemlist("git branch --format='%(refname:short)'")
        vim.ui.select(branches, { prompt = "Select branch or commit hash:" }, function(branch)
          if branch then
            vim.cmd("DiffviewOpen " .. branch .. "... --imply-local")
          end
        end)
      end,
      desc = "Diff with branch or commit hash",
    },
  },
}
