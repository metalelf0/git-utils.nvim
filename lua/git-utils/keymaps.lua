local M = {}
local config = require("git-utils.config")
local core = require("git-utils.core")

-- Setup keymaps based on configuration
function M.setup()
	local keymaps = config.options.keymaps

	-- Create keymaps for each function
	M.set_keymap(keymaps.function_one, core.function_one, "Function One")
	M.set_keymap(keymaps.function_two, core.function_two, "Function Two")
	M.set_keymap(keymaps.function_three, core.function_three, "Function Three")
end

-- Helper to set keymap with proper options
function M.set_keymap(key, func, desc)
	if not key or key == "" then
		return
	end

	vim.keymap.set("n", key, func, {
		desc = desc,
		silent = true,
		noremap = true,
	})
end

return M
