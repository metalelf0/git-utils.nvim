local M = {}
local config = require("git-utils.config")
local core = require("git-utils.core")

-- Setup commands based on configuration
function M.setup()
	local prefix = config.options.command_prefix

	-- Create user commands for each function
	vim.api.nvim_create_user_command(prefix .. "CreateGithubLink", function(opts)
		core.create_github_link(opts.args)
	end, {
		desc = "Create github link",
		nargs = "?",
	})

	vim.api.nvim_create_user_command(prefix .. "CreateGist", function(opts)
		core.create_gist(opts.args, opts.range, opts.line1, opts.line2)
	end, {
		desc = "Create gist",
		nargs = "?",
		range = true,
	})

	vim.api.nvim_create_user_command(prefix .. "OpenPrUrl", function(opts)
		core.open_pr_for_current_line(opts.args)
	end, {
		desc = "Open last PR for current line",
		nargs = "?",
	})
end

return M
