-- local use_window_picker = function(state, path, cmd)
--   local success, picker = pcall(require, "window-picker")
--   if not success then
--     print("You'll need to install window-picker to use this command: https://github.com/s1n7ax/nvim-window-picker")
--     return
--   end
--   local events = require("neo-tree.events")
--   local event_result = events.fire_event(events.FILE_OPEN_REQUESTED, {
--     state = state,
--     path = path,
--     open_cmd = cmd,
--   }) or {}
--   if event_result.handled then
--     events.fire_event(events.FILE_OPENED, path)
--     return
--   end
--   local picked_window_id = picker.pick_window()
--   if picked_window_id then
--     vim.api.nvim_set_current_win(picked_window_id)
--     local result, err = pcall(vim.cmd, cmd .. " " .. vim.fn.fnameescape(path))
--     if result or err == "Vim(edit):E325: ATTENTION" then
--       -- fixes #321
--       vim.api.nvim_buf_set_option(0, "buflisted", true)
--       events.fire_event(events.FILE_OPENED, path)
--     else
--       log.error("Error opening file:", err)
--     end
--   end
-- end
--
-- ---Marks potential windows with letters and will open the give node in the picked window.
-- M.open_with_window_picker = function(state, toggle_directory)
--   open_with_cmd(state, "edit", toggle_directory, use_window_picker)
-- end
--
-- ---Marks potential windows with letters and will open the give node in a split next to the picked window.
-- M.split_with_window_picker = function(state, toggle_directory)
--   open_with_cmd(state, "split", toggle_directory, use_window_picker)
-- end
--
-- ---Marks potential windows with letters and will open the give node in a vertical split next to the picked window.
-- M.vsplit_with_window_picker = function(state, toggle_directory)
--   open_with_cmd(state, "vsplit", toggle_directory, use_window_picker)
-- end
--
-- M.show_help = function(state)
--   local title = state.config and state.config.title or nil
--   local prefix_key = state.config and state.config.prefix_key or nil
--   help.show(state, title, prefix_key)
-- end

return {
  {
    "kevinhwang91/nvim-bqf",
    dependencies = { "junegunn/fzf" },
    event = "VeryLazy",
    ft = "qf",
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        auto_preview = true,
        show_title = false,
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- skip file size greater than 100k
            ret = false
          end
          return ret
        end,
      },
      -- https://github.com/kevinhwang91/nvim-bqf#function-table
      -- set to empty string to disable
      func_map = {
        vsplit = "<C-w>v",
        split = "<C-w>s",
        tab = "<C-w>t",
        filter = "<C-q>",
        stoggledown = "v",
        prevfile = "",
        nextfile = "",
      },
      filter = {
        fzf = {
          action_for = {
            ["<c-w>v"] = "vsplit",
            ["<c-w>s"] = "split",
            ["<c-w>t"] = "tab",
          },
        },
      },
    },
    config = function(_, opts)
      require("bqf").setup(opts)
      -- https://github.com/kevinhwang91/nvim-bqf#format-new-quickfix
      -- no need `yorickpeterse/nvim-pqf`
      local fn = vim.fn

      function _G.qftf(info)
        local items
        local ret = {}
        if info.quickfix == 1 then
          items = fn.getqflist({ id = info.id, items = 0 }).items
        else
          items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
        end
        local limit = 31
        local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
        local validFmt = "%s │%5d:%-3d│%s %s"
        for i = info.start_idx, info.end_idx do
          local e = items[i]
          local fname = ""
          local str
          if e.valid == 1 then
            if e.bufnr > 0 then
              fname = fn.bufname(e.bufnr)
              if fname == "" then
                fname = "[No Name]"
              else
                fname = fname:gsub("^" .. vim.env.HOME, "~")
              end
              -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
              if #fname <= limit then
                fname = fnameFmt1:format(fname)
              else
                fname = fnameFmt2:format(fname:sub(1 - limit))
              end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
            str = validFmt:format(fname, lnum, col, qtype, e.text)
          else
            str = e.text
          end
          table.insert(ret, str)
        end
        return ret
      end
      vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
    end,
  },
  -- {
  --   "yssl/QFEnter",
  --   config = function()
  --     vim.g.qfenter_keymap = {
  --       open = { "<CR>" },
  --       vopen = { "<c-v>" },
  --       hopen = { "<c-h>" },
  --       topen = { "<c-t>" },
  --     }
  --   end,
  -- },
}
