return {
  "renerocksai/telekasten.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  cmd = { "Telekasten" },
		-- stylua: ignore
  keys = {
    { "<localleader>z",  mode = "n", "<cmd>Telekasten panel<CR>",           desc = "Telekasten panel"                  },
    { "<localleader>zf", mode = "n", "<cmd>Telekasten find_notes<CR>",      desc = "Telekasten find   notes"           },
    { "<localleader>zg", mode = "n", "<cmd>Telekasten search_notes<CR>",    desc = "Telekasten search notes"           },
    { "<localleader>zd", mode = "n", "<cmd>Telekasten goto_today<CR>",      desc = "Telekasten goto   today"           },
    { "<localleader>zz", mode = "n", "<cmd>Telekasten follow_link<CR>",     desc = "Telekasten follow link"            },
    { "<localleader>zn", mode = "n", "<cmd>Telekasten new_note<CR>",        desc = "Telekasten new    note       link" },
    { "<localleader>zc", mode = "n", "<cmd>Telekasten show_calendar<CR>",   desc = "Telekasten show   calendar"        },
    { "<localleader>zb", mode = "n", "<cmd>Telekasten show_backlinks<CR>",  desc = "Telekasten show   backlinks"       },
    { "<localleader>zI", mode = "n", "<cmd>Telekasten insert_img_link<CR>", desc = "Telekasten insert img        link" },
    { "[[",              mode = "i", "<cmd>Telekasten insert_link<CR>",     desc = "Telekasten insert link"            },
  },
  opts = {
    home = vim.fn.expand("~/docs/wiki"),
  },
  ft = { "markdown" },
}
