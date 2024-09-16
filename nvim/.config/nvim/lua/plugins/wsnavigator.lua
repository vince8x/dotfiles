return {
  "JohanChane/wsnavigator.nvim",
  lazy = "VeryLazy",
  keys = {
    {
      "<localleader>tt",
      function()
        local wsn = require("wsnavigator")
        wsn.set_opts({ jumplist = { buf_only = true } })
        wsn.open_wsn()
      end,
      desc = "Open Wsnavigator",
    },
    {
      "<localleader>tj",
      function()
        local wsn = require("wsnavigator")
        wsn.set_opts({ jumplist = { buf_only = false } })
        wsn.open_wsn()
      end,
      desc = "Open Jumplist",
    },
    {
      "<localleader>ts",
      function()
        local wsn = require("wsnavigator")
        wsn.switch_display_mode()
      end,
      desc = "Switch display mode",
    },
  },
  config = function()
    require("wsnavigator").setup({
      ui = {
        float = {
          border = "single", -- see ':h nvim_open_win'
          float_hl = "Normal", -- see ':h winhl'
          border_hl = "Normal",
          blend = 0, -- see ':h winblend'
          height = 0.9, -- Num from 0 - 1 for measurements
          width = 0.9,
          x = 0.5, -- X and Y Axis of Window
          y = 0.4,
        },
      },
      max_len_of_entries = 20, -- max length of entries.
      display_mode = "filetree", -- filetree | list
      jumplist = {
        buf_only = false, -- show buf_only
      },
      filetree = {
        --theme = { -- user your theme
        --  indent = '  ',
        --  branch = '│ ',
        --  last_child = '└─',
        --  mid_child = '├─',
        --},
        theme_name = "classic", -- 'classic' | 'fine' | 'bold' | 'dotted'
        -- | 'minimal' | 'double' | 'arrows' | 'simple' | 'tree' | 'compact_tree'
      },
      theme = {
        --entry_hls = {     -- Ref `default_entry_hls`
        --  WsnKey = { fg = '#ff0000' },
        --}
      },
    })
  end,
}
