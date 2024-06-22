return {
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/which-key.nvim",
    },
    config = function()
      require("gitsigns").setup({

        on_attach = function(bufnr)
          require("which-key").register({
            ["]h"] = { "<cmd>lua require('gitsigns').next_hunk()<CR>", "Next Hunk" },
            ["[h"] = { "<cmd>lua require('gitsigns').prev_hunk()<CR>", "Previous Hunk" },
            ["]H"] = { "<cmd>lua require('gitsigns').nav_hunk('last)<CR>", "Last Hunk" },
            ["[H"] = { "<cmd>lua require('gitsigns').nav_hunk('first)<CR>", "First Hunk" },

            -- Actions
            ["<leader>ghs"] = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk" },
            ["<leader>ghr"] = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },

            ["<leader>ghS"] = { "<cmd>lua require('gitsigns').stage_buffer()<CR>", "Stage Buffer" },
            ["<leader>ghu"] = { "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>", "Undo Stage Hunk" },
            ["<leader>ghR"] = { "<cmd>lua require('gitsigns').reset_buffer()<CR>", "Reset Buffer" },
            ["<leader>ghp"] = { "<cmd>lua require('gitsigns').preview_hunk()<CR>", "Preview Hunk" },
            ["<leader>ghb"] = { "<cmd>lua require('gitsigns').blame_line{full=true}<CR>", "Blame Line" },
            ["<leader>tb"] = {
              "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>",
              "Toggle Line Blame",
            },
            ["<leader>ghd"] = { "<cmd>lua require('gitsigns').diffthis()<CR>", "Diff This" },
            ["<leader>ghD"] = { "<cmd>lua require('gitsigns').diffthis('~')<CR>", "Diff This ~" },
            ["<leader>td"] = { "<cmd>lua require('gitsigns').toggle_deleted()<CR>", "Toggle Deleted" },
          }, { mode = "n", buffer = bufnr })

          require("which-key").register({
            ["<leader>hs"] = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk" },
            ["<leader>hr"] = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
          }, { mode = "v", buffer = bufnr })

          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          -- -- stylua: ignore start
          -- map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
          -- map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")
          -- map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
          -- map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
          --
          -- map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
          -- map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
          --
          -- map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
          -- map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
          -- map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
          -- map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
          -- map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
          -- map("n", "<leader>ghd", gs.diffthis, "Diff This")
          -- map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        end,
      })
    end,
  },
}
