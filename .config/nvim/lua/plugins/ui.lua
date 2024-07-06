return {
  {

    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        hint = "floating-big-letter",
        selection_chars = "TNSERIAOC<X>DHWYFU",
      })
    end,
    keys = {
      {
        "<localleader>w",
        function()
          local win = require("window-picker").pick_window()
          if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
          end
        end,
        desc = "Window Picker: Pick",
      },
    },
  },
}
