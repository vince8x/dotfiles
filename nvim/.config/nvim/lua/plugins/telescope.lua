return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      "princejoogie/dir-telescope.nvim",
    },
  },
  opts = function(_, opts)
    local lga_actions = require("telescope-live-grep-args.actions")
    local actions = require("telescope.actions")
    opts.extensions = {
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        -- define mappings, e.g.
        mappings = { -- extend mappings
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            -- freeze the current list and start a fuzzy search in the frozen list
            ["<C-space>"] = actions.to_fuzzy_refine,
          },
        },
        -- https://stackoverflow.com/questions/77980402/is-there-a-way-to-grep-on-files-that-are-returned-by-telescopes-live-grep
        -- ... also accepts theme settings, for example:
        -- theme = "dropdown", -- use dropdown theme
        -- theme = { }, -- use own theme spec
        -- layout_config = { mirror=true }, -- mirror preview pane
      },
    }
    opts.defaults = vim.tbl_extend("force", opts.defaults, {
      mappings = {
        i = {
          ["<C-n>"] = require("telescope.actions").move_selection_next,
          ["<C-e>"] = require("telescope.actions").move_selection_previous,
        },
        n = { -- while in normal mode
          ["<C-n>"] = require("telescope.actions").move_selection_next,
          ["<C-e>"] = require("telescope.actions").move_selection_previous,
          ["<PageUp>"] = require("telescope.actions").results_scrolling_up,
          ["<PageDown>"] = require("telescope.actions").results_scrolling_down,
          ["<C-f>"] = {
            function(p_bufnr)
              -- send results to quick fix list
              require("telescope.actions").send_to_qflist(p_bufnr)
              local qflist = vim.fn.getqflist()
              local paths = {}
              local hash = {}
              for k in pairs(qflist) do
                local path = vim.fn.bufname(qflist[k]["bufnr"]) -- extract path from quick fix list
                if not hash[path] then -- add to paths table, if not already appeared
                  paths[#paths + 1] = path
                  hash[path] = true -- remember existing paths
                end
              end
              -- show search scope with message
              vim.notify("find in ...\n  " .. table.concat(paths, "\n  "))
              -- execute live_grep_args with search scope
              require("telescope").extensions.live_grep_args.live_grep_args({ search_dirs = paths })
            end,
            type = "action",
            opts = {
              nowait = true,
              silent = true,
              desc = "Live grep on results",
            },
          },
        },
      },
    })
  end,
  keys = {
    {
      "<leader>/",
      "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
      desc = "Grep (root dir)",
    },
    {
      "<leader>sp",
      function()
        require("telescope").extensions.dir.live_grep()
      end,
      desc = "Live grep in selected directory",
    },
    {
      "<leader>fd",
      function()
        require("telescope").extensions.dir.find_files()
      end,
      desc = "Find file in selected directory",
    },
  },
  config = function(_, opts)
    local tele = require("telescope")
    tele.setup(opts)

    require("dir-telescope").setup({
      hidden = false,
      no_ignore = false,
      show_preview = true,
    })

    tele.load_extension("live_grep_args")
    tele.load_extension("dir")
  end,
}
