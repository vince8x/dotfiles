--- Ergoterm.nvim terminal provider for Claude Code.
-- @module terminal.ergoterm

local M = {}

local terminal = nil

--- Builds ergoterm Terminal options
--- @param config table Terminal configuration (split_side, split_width_percentage, etc.)
--- @param env_table table Environment variables to set for the terminal process
--- @param cmd_string string Command to run in terminal
--- @return table Ergoterm Terminal configuration
local function build_terminal_opts(config, env_table, cmd_string)
	local layout = config.split_side == "left" and "left" or "right"
	local width_percentage = string.format("%.0f%%", config.split_width_percentage * 100)
	local close_on_exit = config.auto_close or false

	return {
		name = "claude-code",
		cmd = cmd_string,
		layout = layout,
		env = env_table,
		close_on_job_exit = close_on_exit,
		size = {
			right = width_percentage,
			left = width_percentage,
		},
	}
end

function M.is_available()
	local ergoterm_available, _ergoterm = pcall(require, "ergoterm.terminal")
	return ergoterm_available
end

function M.is_started()
	return terminal and terminal:is_started()
end

function M.ensure_visible()
	if terminal and not terminal:is_open() then
		terminal:open()
	end
end

function M.toggle_open_no_focus()
	M.ensure_visible()
end

function M.setup()
	if not M.is_available() then
		vim.notify("Failed to load ergoterm.terminal", vim.log.levels.ERROR)
		return
	end
end

--- @param cmd_string string
--- @param env_table table
--- @param config table
--- @param focus boolean|nil
function M.open(cmd_string, env_table, config, focus)
	if not terminal then
		local opts = build_terminal_opts(config, env_table, cmd_string)
		terminal = require("ergoterm.terminal").Terminal:new(opts)
	end

	terminal:open()
	if focus then
		terminal:focus()
	end
end

function M.close()
	if terminal and terminal:is_open() then
		terminal:close()
	end
end

--- Simple toggle: always show/hide terminal regardless of focus
--- @param cmd_string string
--- @param env_table table
--- @param config table
function M.simple_toggle(cmd_string, env_table, config)
	if M.is_started() then
		if terminal:is_open() then
			terminal:close()
		else
			terminal:focus()
		end
	else
		M.open(cmd_string, env_table, config, true)
	end
end

--- Smart focus toggle: switches to terminal if not focused, hides if currently focused
--- @param cmd_string string
--- @param env_table table
--- @param config table
function M.focus_toggle(cmd_string, env_table, config)
	if M.is_started() then
		if terminal:is_focused() then
			terminal:close()
		else
			terminal:focus()
		end
	else
		M.open(cmd_string, env_table, config, true)
	end
end

--- @return number|nil
function M.get_active_bufnr()
	if M.is_started() then
		-- ergoterm doesn't expose buffer directly, but we can try to get it
		-- from the terminal's internal state if available
		if terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
			return terminal.buf
		end
	end
	return nil
end

return M
