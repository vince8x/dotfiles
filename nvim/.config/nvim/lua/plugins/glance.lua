return {
  {
    "dnlhc/glance.nvim",
    keys = {
      { "gD", "<CMD>Glance definitions<CR>" },
      { "gR", "<CMD>Glance references<CR>" },
      { "gY", "<CMD>Glance type_definitions<CR>" },
      { "gM", "<CMD>Glance implementations<CR>" },
    },
  },
  {
    "WilliamHsieh/overlook.nvim",
    opts = {},

    -- Optional: set up common keybindings
    keys = {
      {
        "<leader>pd",
        function()
          require("overlook.api").peek_definition()
        end,
        desc = "Overlook: Peek definition",
      },
      {
        "<leader>pc",
        function()
          require("overlook.api").close_all()
        end,
        desc = "Overlook: Close all popup",
      },
      {
        "<leader>pu",
        function()
          require("overlook.api").restore_popup()
        end,
        desc = "Overlook: Restore popup",
      },
    },
  },
}
