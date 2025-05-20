local M = {}
local config = require("git-utils.config")

-- Core functionality implementation

-- Function One
function M.function_one(arg)
	-- Get options from config
	local option_one = config.options.option_one
	local option_two = config.options.option_two

	-- Implementation logic here
	vim.notify("Function One called with arg: " .. (arg or "none"))
	vim.notify("Using option_one: " .. tostring(option_one))
	vim.notify("Using option_two: " .. option_two)
end

-- Function Two
function M.function_two(arg)
	-- Get options from config
	local option_three = config.options.option_three

	-- Implementation logic here
	vim.notify("Function Two called with arg: " .. (arg or "none"))
	vim.notify("Using option_three: " .. tostring(option_three))
end

-- Function Three
function M.function_three(arg)
	-- Implementation logic here
	vim.notify("Function Three called with arg: " .. (arg or "none"))

	-- Example: use different behavior based on options
	if config.options.option_one then
		vim.notify("Doing the first thing")
	else
		vim.notify("Doing the alternative thing")
	end
end

return M
