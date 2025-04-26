local github_key_maps = function()
  local wk = require("which-key")
  wk.add({
    { "<localleader>gh", group = "Github" },
    { "<localleader>ghc", group = "Commits" },
    { "<localleader>ghcc", "<cmd>GHCloseCommit<cr>", desc = "Close" },
    { "<localleader>ghce", "<cmd>GHExpandCommit<cr>", desc = "Expand" },
    { "<localleader>ghco", "<cmd>GHOpenToCommit<cr>", desc = "Open To" },
    { "<localleader>ghcp", "<cmd>GHPopOutCommit<cr>", desc = "Pop Out" },
    { "<localleader>ghcz", "<cmd>GHCollapseCommit<cr>", desc = "Collapse" },
    { "<localleader>ghi", group = "Issues" },
    { "<localleader>ghip", "<cmd>GHPreviewIssue<cr>", desc = "Preview" },
    { "<localleader>ghl", group = "Litee" },
    { "<localleader>ghlt", "<cmd>LTPanel<cr>", desc = "Toggle Panel" },
    { "<localleader>ghq", group = "Pull Request" },
    { "<localleader>ghqc", "<cmd>GHClosePR<cr>", desc = "Close" },
    { "<localleader>ghqd", "<cmd>GHPRDetails<cr>", desc = "Details" },
    { "<localleader>ghqe", "<cmd>GHExpandPR<cr>", desc = "Expand" },
    { "<localleader>ghqo", "<cmd>GHOpenPR<cr>", desc = "Open" },
    { "<localleader>ghqp", "<cmd>GHPopOutPR<cr>", desc = "PopOut" },
    { "<localleader>ghqr", "<cmd>GHRefreshPR<cr>", desc = "Refresh" },
    { "<localleader>ghqt", "<cmd>GHOpenToPR<cr>", desc = "Open To" },
    { "<localleader>ghqz", "<cmd>GHCollapsePR<cr>", desc = "Collapse" },
    { "<localleader>ght", group = "Threads" },
    { "<localleader>ghtc", "<cmd>GHCreateThread<cr>", desc = "Create" },
    { "<localleader>ghtn", "<cmd>GHNextThread<cr>", desc = "Next" },
    { "<localleader>ghtt", "<cmd>GHToggleThread<cr>", desc = "Toggle" },
    { "<localleader>ghv", group = "Review" },
    { "<localleader>ghvb", "<cmd>GHStartReview<cr>", desc = "Begin" },
    { "<localleader>ghvc", "<cmd>GHCloseReview<cr>", desc = "Close" },
    { "<localleader>ghvd", "<cmd>GHDeleteReview<cr>", desc = "Delete" },
    { "<localleader>ghve", "<cmd>GHExpandReview<cr>", desc = "Expand" },
    { "<localleader>ghvs", "<cmd>GHSubmitReview<cr>", desc = "Submit" },
    { "<localleader>ghvz", "<cmd>GHCollapseReview<cr>", desc = "Collapse" },
  })
end

return {
  {
    "ldelossa/gh.nvim",
    dependencies = {
      {
        "ldelossa/litee.nvim",
        config = function()
          require("litee.lib").setup()
        end,
      },
    },
    config = function()
      require("litee.gh").setup()
      github_key_maps()
    end,
  },
  {
    "johnseth97/gh-dash.nvim",
    lazy = true,
    keys = {
      {
        "<leader>ghc",
        function()
          require("gh_dash").toggle()
        end,
        desc = "Toggle gh-dash popup",
      },
    },
    opts = {
      keymaps = {}, -- disable internal mapping
      border = "rounded", -- or 'double'
      width = 0.8,
      height = 0.8,
      autoinstall = true,
    },
  },
}
