return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    lazy = false,
    requires = {
      "nvim-lua/plenary.nvim",
      "folke/which-key.nvim",
    },
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    config = function()
      require("harpoon").setup({})

      local function toggle_telescope_with_harpoon(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = require("telescope.config").values.file_previewer({}),
            sorter = require("telescope.config").values.generic_sorter({}),
          })
          :find()
      end
    end,
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "add harpoon file",
      },
      {
        "<leader>hd",
        function()
          require("harpoon"):list():remove()
        end,
        desc = "remove harpoon file",
      },
      {
        "<leader>hh",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "harpoon quick menu",
      },
      {
        "<leader>1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "harpoon to file 1",
      },
      {
        "<leader>2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "harpoon to file 2",
      },
      {
        "<leader>3",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "harpoon to file 3",
      },
      {
        "<leader>4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "harpoon to file 4",
      },
      {
        "<leader>5",
        function()
          require("harpoon"):list():select(5)
        end,
        desc = "harpoon to file 5",
      },
      {
        "<C-M-Left>",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "harpoon to prev",
      },
      {
        "<C-M-Right>",
        function()
          require("harpoon"):list():next()
        end,
        desc = "harpoon to next",
      },
    },
  },
}
