local M = {}
local config = require("git-utils.config")
local core = require("git-utils.core")

-- Setup keymaps based on configuration
function M.setup()
	local keymaps = config.options.keymaps

	-- Create keymaps for each function
	M.set_keymap("n", keymaps.create_github_link, core.create_github_link, "Create github link")
	M.set_keymap("v", keymaps.create_gist, core.create_gist, "Create gist")
	M.set_keymap("n", keymaps.open_pr_for_current_line, core.open_pr_for_current_line, "Open PR for current line")
end

-- Helper to set keymap with proper options
function M.set_keymap(mode, key, func, desc)
	if not key or key == "" then
		return
	end

	vim.keymap.set(mode, key, func, {
		desc = desc,
		silent = true,
		noremap = true,
	})
end

return M
