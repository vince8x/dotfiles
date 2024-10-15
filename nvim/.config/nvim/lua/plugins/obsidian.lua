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
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "notes/dailies",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily-notes" },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = nil,
      },
      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 3 chars.
        min_chars = 3,
      },
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
      templates = {
        folder = "5. Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },
      -- ui = {
      --   enabled = false,
      -- },
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
