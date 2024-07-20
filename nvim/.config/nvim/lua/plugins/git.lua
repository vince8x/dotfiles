return {
  "ThePrimeagen/git-worktree.nvim",
  lazy = false,
  config = function()
    require("git-worktree").setup({})
    require("telescope").load_extension("git_worktree")
  end,
  keys = {
    {
      "<leader>gwt",
      function()
        require("telescope").extensions.git_worktree.git_worktrees()
      end,
      desc = "Git Worktree switch",
    },
    {
      "<leader>gwn",
      function()
        require("telescope").extensions.git_worktree.create_git_worktree()
      end,
      desc = "Git Worktree new branch",
    },
    {
      "<leader>gw",
      desc = "Git Worktree",
    },
  },
}
