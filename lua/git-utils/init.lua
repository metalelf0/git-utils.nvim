-- Main entry point for the plugin
local M = {}

-- Store module references
M.config = require("git-utils.config")
M.core = require("git-utils.core")

-- Setup function to configure the plugin
function M.setup(opts)
	-- Merge user options with defaults
	opts = opts or {}
	M.config.set_options(opts)

	-- Setup keymaps if not disabled
	if not M.config.options.disable_keymaps then
		require("git-utils.keymaps").setup()
	end

	-- Setup commands if not disabled
	if not M.config.options.disable_commands then
		require("git-utils.commands").setup()
	end

	return M
end

-- Export public API functions
M.create_github_link = M.core.create_github_link
M.create_gist = M.core.create_gist
M.open_pr_for_current_line = M.core.open_pr_for_current_line

return M
