return {
  {
    "xb-bx/editable-term.nvim",
    config = true,
  },
  {
    "waiting-for-dev/ergoterm.nvim",
    opts = {
      picker = {
        picker = "fzf-lua",
      },
    },
    config = function(_, opts)
      require("ergoterm").setup(opts)

      local terms = require("ergoterm.terminal")

      local base = terms.Terminal:new({
        name = "base",
        cmd = "zsh",
        layout = "below",
        -- dir = "git_dir",
      })

      -- RUtils.map.vnoremap("<Localleader>t", function()
      --   base:toggle()
      -- end, { desc = "toggle base terminal" })
      -- RUtils.map.nnoremap("<Localleader>t", function()
      --   base:toggle()
      -- end, { desc = "toggle base terminal" })
      -- RUtils.map.tnoremap("<Localleader>t", function()
      --   base:toggle()
      -- end, { desc = "toggle base terminal" })
      --
      -- RUtils.map.vnoremap("<a-f>", function()
      --   base:toggle()
      -- end, { desc = "toggle base terminal" })
      -- RUtils.map.nnoremap("<a-f>", function()
      --   base:toggle()
      -- end, { desc = "toggle base terminal" })
      -- RUtils.map.tnoremap("<a-f>", function()
      --   base:toggle()
      -- end, { desc = "toggle base terminal" })
    end,
  },
}
