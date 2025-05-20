local M = {}
local config = require("git-utils.config")
local core = require("git-utils.core")

-- Setup commands based on configuration
function M.setup()
	local prefix = config.options.command_prefix

	-- Create user commands for each function
	vim.api.nvim_create_user_command(prefix .. "FunctionOne", function(opts)
		core.function_one(opts.args)
	end, {
		desc = "Execute function one",
		nargs = "?",
	})

	vim.api.nvim_create_user_command(prefix .. "FunctionTwo", function(opts)
		core.function_two(opts.args)
	end, {
		desc = "Execute function two",
		nargs = "?",
	})

	vim.api.nvim_create_user_command(prefix .. "FunctionThree", function(opts)
		core.function_three(opts.args)
	end, {
		desc = "Execute function three",
		nargs = "?",
	})
end

return M
