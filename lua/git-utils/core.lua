local M = {}
local config = require("git-utils.config")
local json = vim.fn.json_encode -- Use json_encode for request body formatting
local curl = vim.fn.system -- Use system to execute curl commands

-- Core functionality implementation

function M.create_github_link(_arg)
	local handle = io.popen("git config --get remote.origin.url")
	local git_url = handle:read("*a"):gsub("%s+", "")
	handle:close()

	-- Convert 'git@github.com:username/repo.git' to 'https://github.com/username/repo'
	-- TODO: extract this to a function in utils.lua
	git_url = git_url:gsub("git@github.com:", "https://github.com/"):gsub("%.git$", "")

	-- Get the current branch
	local branch_handle = io.popen("git rev-parse --abbrev-ref HEAD")
	local branch = branch_handle:read("*a"):gsub("%s+", "")
	branch_handle:close()

	-- Get the filename inside the current buffer
	local filename = vim.fn.expand("%:L")

	-- Get the current line number where the cursor is
	local line_number = vim.fn.line(".")

	-- Construct the GitHub URL
	local github_url = git_url .. "/blob/" .. branch .. "/" .. filename .. "#L" .. line_number

	-- Output the URL (this can also copy it to the clipboard)
	print(github_url)
	vim.fn.setreg("+", github_url) -- Copy to clipboard
end

function M.create_gist(arg, has_range, line1, line2)
	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.bo[bufnr].filetype
	local token = config.options.gist_token
	if token == nil or token == "" then
		print("GitHub token not found. Please set opts.gist_token (see README.md).")
		return
	end

	local content = ""

	if has_range then
		-- Get the current visual selection
		local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
		content = table.concat(lines, "\n")
	else
		-- Get the whole file
		local lines = vim.api.nvim_buf_get_lines(0, 1, -1, false)
		content = table.concat(lines, "\n")
	end

	-- Get the current filetype for Gist syntax highlighting
	-- local filetype = vim.bo.filetype or "txt"

	-- Prepare Gist request body
	local gist_body = {
		description = "Created from Neovim",
		public = false, -- Make the Gist private
		files = {
			["gistfile." .. filetype] = {
				content = content,
			},
		},
	}

	-- Convert the body to JSON
	local json_body = json(gist_body)

	-- Execute curl command to create the Gist
	local result = vim.fn.system({
		"curl",
		"-s",
		"-X",
		"POST",
		"-H",
		"Authorization: token " .. token,
		"-H",
		"Content-Type: application/json",
		"-d",
		json_body,
		"https://api.github.com/gists",
	})

	-- Parse the JSON response to extract the URL
	local gist_data = vim.fn.json_decode(result)

	if gist_data and gist_data.html_url then
		-- Copy the Gist URL to the clipboard and print it
		vim.fn.setreg("+", gist_data.html_url)
		print("Gist created: " .. gist_data.html_url)
	else
		print("Failed to create Gist: " .. vim.inspect(gist_data))
	end
end

function M.open_pr_for_current_line(arg)
	local line_num = vim.api.nvim_win_get_cursor(0)[1]
	local file_path = vim.fn.expand("%:p")

	-- Get the commit hash for the current line
	local blame_cmd = string.format("git blame -L %d,%d %s", line_num, line_num, file_path)
	local blame_output = vim.fn.system(blame_cmd)
	local commit_hash = blame_output:match("^(%x+)")

	if not commit_hash or commit_hash:match("^0+$") then
		print("Couldn't find commit hash for this line")
		return
	end

	-- Find PR number from commit message
	local pr_cmd = string.format('git show --format="%%s" %s', commit_hash)
	local commit_msg = vim.fn.system(pr_cmd)
	local pr_number = commit_msg:match("%(#(%d+)%)")

	if not pr_number then
		-- Try alternative patterns for PR references
		pr_number = commit_msg:match("Merge pull request #(%d+)") or commit_msg:match("#(%d+)")
	end

	if pr_number then
		-- Get the remote URL
		local remote_url = vim.fn.system("git remote get-url origin"):gsub("%s+$", "")
		local repo_path

		-- Handle SSH format: git@github.com:organization/repo_name.git
		if remote_url:match("^git@github%.com:(.+)%.git") then
			repo_path = remote_url:match("git@github%.com:(.+)%.git")
		-- Handle HTTPS format: https://github.com/organization/repo_name.git
		elseif remote_url:match("github%.com") then
			repo_path = remote_url:match("git@github%.com:(.+)")
		elseif remote_url:match("github%.com") then
			repo_path = remote_url:match("github%.com[:/](.+)%.git")
		end

		if repo_path then
			local pr_url = string.format("https://github.com/%s/pull/%s", repo_path, pr_number)

			-- Detect OS and open browser accordingly
			local open_cmd
			if vim.fn.has("mac") == 1 then
				open_cmd = "open"
			elseif vim.fn.has("unix") == 1 then
				open_cmd = "xdg-open"
			elseif vim.fn.has("win32") == 1 then
				open_cmd = "start"
			end

			if open_cmd then
				vim.fn.system(string.format('%s "%s"', open_cmd, pr_url))
				print("Opening PR #" .. pr_number)
			else
				print("PR URL: " .. pr_url)
			end
		else
			print("Couldn't parse repository path from remote URL: " .. remote_url)
		end
	else
		print("Couldn't find PR number in commit message: " .. commit_msg:sub(1, 50) .. "...")

		-- Fallback: open the commit directly
		local remote_url = vim.fn.system("git remote get-url origin"):gsub("%s+$", "")
		local repo_path

		if remote_url:match("^git@github%.com:") then
			repo_path = remote_url:match("git@github%.com:(.+)%.git")
		elseif remote_url:match("github%.com") then
			repo_path = remote_url:match("github%.com[:/](.+)%.git")
		end

		if repo_path then
			local commit_url = string.format("https://github.com/%s/commit/%s", repo_path, commit_hash)
			print("No PR found. Opening commit instead: " .. commit_hash:sub(1, 7))

			local open_cmd
			if vim.fn.has("mac") == 1 then
				open_cmd = "open"
			elseif vim.fn.has("unix") == 1 then
				open_cmd = "xdg-open"
			elseif vim.fn.has("win32") == 1 then
				open_cmd = "start"
			end

			if open_cmd then
				vim.fn.system(string.format('%s "%s"', open_cmd, commit_url))
			else
				print("Commit URL: " .. commit_url)
			end
		end
	end
end

return M
