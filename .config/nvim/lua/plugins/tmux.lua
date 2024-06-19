return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      { "<c-left>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-down>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-up>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-right>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    },
    require("module"),
  },
}
