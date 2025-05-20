local M = {}

-- Default configuration
M.defaults = {
	-- Plugin behavior options
	gist_token = vim.fn.getenv("GIST_TOKEN"),

	-- Keymap options
	disable_keymaps = false,
	keymaps = {
		create_github_link = "<leader>gul",
		create_gist = "<leader>gug",
		open_pr_for_current_line = "<leader>gup",
	},

	-- Command options
	disable_commands = false,
	command_prefix = "GitUtils",
}

-- Current active options
M.options = vim.deepcopy(M.defaults)

-- Set options, merging with defaults
function M.set_options(opts)
	opts = opts or {}

	-- Handle keymaps separately to allow partial override
	if opts.keymaps then
		opts.keymaps = vim.tbl_deep_extend("force", M.options.keymaps, opts.keymaps)
	end

	-- Merge options
	M.options = vim.tbl_deep_extend("force", M.options, opts)
end

return M
