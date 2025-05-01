return {
  "tristone13th/lspmark.nvim",
  keys = {
    { "<localleader>m", "", desc = "Bookmark" },
    { "<localleader>mb", "<cmd>Telescope lspmark<cr>", desc = "Bookmark" },
    {
      "<localleader>mn",
      function()
        require("lspmark.bookmarks").toggle_bookmark({ with_comment = false })
      end,
      desc = "Bookmark",
    },
    {
      "<localleader>mc",
      function()
        require("lspmark.bookmarks").toggle_bookmark({ with_comment = true })
      end,
      desc = "Bookmark With Comment",
    },
    {
      "<localleader>ms",
      function()
        require("lspmark.bookmarks").show_comment()
      end,
      desc = "Show Comment",
    },
    {
      "<localleader>me",
      function()
        require("lspmark.bookmarks").modify_comment()
      end,
      desc = "Modify Comment",
    },
    {
      "<localleader>md",
      function()
        require("lspmark.bookmarks").delete_line()
      end,
      desc = "Delete Line",
    },
    {
      "<localleader>mv",
      function()
        require("lspmark.bookmarks").delete_visual_selection()
      end,
      desc = "Delete Selection",
    },
    {
      "<localleader>mp",
      function()
        require("lspmark.bookmarks").paste_text()
      end,
      desc = "Paste Text",
    },
  },
}
