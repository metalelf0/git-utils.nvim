local M = {}

-- Default configuration
M.defaults = {
	-- Plugin behavior options
	option_one = true,
	option_two = "default_value",
	option_three = 100,

	-- Keymap options
	disable_keymaps = false,
	keymaps = {
		function_one = "<leader>f1",
		function_two = "<leader>f2",
		function_three = "<leader>f3",
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
