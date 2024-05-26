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
      { "<c-m>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-n>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-e>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-i>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    },
  },
}
