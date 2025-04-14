return {
  {
    "2KAbhishek/pickme.nvim",
    cmd = "PickMe",
    event = "VeryLazy",
    dependencies = {
      "folke/snacks.nvim",
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
    },
    opts = {
      picker_provider = "snacks",
      add_default_keybindings = false,
    },
  },
  -- {
  --   "2kabhishek/markit.nvim",
  --   config = load_config("tools.markit"),
  --   event = { "BufReadPost", "BufNewFile" },
  -- },
  {
    "2KAbhishek/octohub.nvim",
    cmd = {
      "OctoRepos",
      "OctoReposByCreated",
      "OctoReposByForks",
      "OctoReposByIssues",
      "OctoReposByLanguages",
      "OctoReposByNames",
      "OctoReposByPushed",
      "OctoReposBySize",
      "OctoReposByStars",
      "OctoReposByUpdated",
      "OctoReposTypeArchived",
      "OctoReposTypeForked",
      "OctoReposTypePrivate",
      "OctoReposTypeStarred",
      "OctoReposTypeTemplate",
      "OctoRepo",
      "OctoStats",
      "OctoActivityStats",
      "OctoContributionStats",
      "OctoRepoStats",
      "OctoProfile",
      "OctoRepoWeb",
    },
    keys = {
      "<locallader>goa",
      "<locallader>goA",
      "<locallader>gob",
      "<locallader>goc",
      "<locallader>gof",
      "<locallader>goF",
      "<locallader>gog",
      "<locallader>goi",
      "<locallader>gol",
      "<locallader>goo",
      "<locallader>gop",
      "<locallader>goP",
      "<locallader>gor",
      "<locallader>gos",
      "<locallader>goS",
      "<locallader>got",
      "<locallader>goT",
      "<locallader>gou",
      "<locallader>goU",
      "<locallader>gow",
    },
    dependencies = {
      "2kabhishek/utils.nvim",
      "2kabhishek/pickme.nvim",
    },
  },
}
