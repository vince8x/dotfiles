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
  {
    "isakbm/gitgraph.nvim",
    opts = {
      git_cmd = "git",
      symbols = {
        merge_commit = "M",
        commit = "*",
      },
      format = {
        timestamp = "%H:%M:%S %d-%m-%Y",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        on_select_commit = function(commit)
          print("selected commit:", commit.hash)
        end,
        on_select_range_commit = function(from, to)
          print("selected range:", from.hash, to.hash)
        end,
      },
    },
    keys = {
      {
        "<localleader>gg",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Draw",
      },
    },
  },
}
