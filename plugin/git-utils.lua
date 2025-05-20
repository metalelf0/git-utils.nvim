-- Early return if plugin is disabled or not compatible
if vim.g.loaded_gitutils == 1 then
	return
end
vim.g.loaded_gitutils = 1

-- Minimum Neovim version check
if vim.fn.has("nvim-0.7.0") == 0 then
	vim.api.nvim_err_writeln("git-utils.nvim requires at least Neovim 0.7.0")
	return
end

-- This file is loaded automatically by Neovim
-- We only need it to set the plugin as loaded
-- The actual functionality is in the lua/ directory
