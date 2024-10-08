return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre */obsidian/*/**.md",
      "BufNewFile */obsidian/*/**.md",
    },
    keys = {
      { "<localleader>ob", "<Cmd>ObsidianBacklinks<CR>", desc = "obsidian: buffer backlinks" },
      { "<localleader>od", "<Cmd>ObsidianToday<CR>", desc = "obsidian: open daily note" },
      { "<localleader>on", ":ObsidianNew ", desc = "obsidian: new note" },
      { "<localleader>oy", "<Cmd>ObsidianYesterday<CR>", desc = "obsidian: previous daily note" },
      { "<localleader>oo", ":ObsidianOpen ", desc = "obsidian: open in app" },
      { "<localleader>os", "<Cmd>ObsidianSearch<CR>", desc = "obsidian: search" },
      { "<localleader>ot", "<Cmd>ObsidianTemplate<CR>", desc = "obsidian: insert template" },
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Sync/obsidian/obsidian_vault",
        },
      },
      ui = {
        enabled = false,
      },
      -- see below for full list of options 👇
    },
  },
  -- {
  --   'nvim-neorg/neorg',
  --   cond = false,
  --   ft = 'norg',
  --   keys = {
  --     { '<localleader>nx', '<cmd>Neorg return<CR>', 'neorg: return' },
  --     { '<localleader>ni', '<cmd>Neorg index<CR>', 'neorg: open default' },
  --   },
  --   build = ':Neorg sync-parsers',
  --   dependencies = { 'vhyrro/neorg-telescope', 'max397574/neorg-contexts' },
  --   opts = {
  --     configure_parsers = true,
  --     load = {
  --       ['core.defaults'] = {},
  --       ['core.integrations.telescope'] = {},
  --       ['core.keybinds'] = {
  --         config = {
  --           default_keybinds = true,
  --           neorg_leader = '<localleader>',
  --           hook = function(keybinds)
  --             keybinds.unmap('norg', 'n', '<C-s>')
  --             keybinds.map_event(
  --               'norg',
  --               'n',
  --               '<C-x>',
  --               'core.integrations.telescope.find_linkable'
  --             )
  --           end,
  --         },
  --       },
  --       ['core.completion'] = { config = { engine = 'nvim-cmp' } },
  --       ['core.concealer'] = {},
  --       ['core.dirman'] = {
  --         config = {
  --           workspaces = {
  --             notes = sync('neorg'),
  --             tasks = sync('neorg/neovim'),
  --             work = sync('neorg/work'),
  --           },
  --           default_workspace = 'notes',
  --         },
  --       },
  --       ['external.context'] = {},
  --     },
  --   },
  -- },
}
