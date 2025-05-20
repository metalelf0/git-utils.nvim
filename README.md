# git-utils.nvim

This plugin is a set of utility functions related to git (and github) usage.

## `GitUtilsCreateGithubLink`

- command name: `GitUtilsCreateGithubLink`
- default keybind: `<leader>gul` (mnemonic: git-utils-link)
- description: creates a link to the current line in the current file in the current branch on github, and copies it to clipboard.

## `GitUtilsCreateGist`

- command name: `GitUtilsCreateGist`
- default keybind: `<leader>gug` (mnemonic: git-utils-gist)
- description: posts the current visual selection to gist and copies link to clipboard.
- requirements: the `gist_token` option must be set (see below for details).

## `GitUtilsOpenPrUrl`

- command name: `GitUtilsOpenPrUrl`
- default keybind: `<leader>gup` (mnemonic: git-utils-pr)
- description: open the PR that introduced the latest change to the current line.

# Setup and configuration

Install the plugin with lazy.nvim:

```lua
return {
  "metalelf0/git-utils.nvim",
  config = function()
    require("git-utils").setup({
      gist_token = vim.fn.getenv("GIST_TOKEN"),
      
      -- Customize keymaps
      disable_keymaps = false,
      keymaps = {
		create_github_link = "<leader>gul",
		create_gist = "<leader>gug",
		open_pr_for_current_line = "<leader>gup",
      },
      
      -- Command options
      disable_commands = false,
      command_prefix = "GitUtils",
    })
  end,
}
```

Or with `packer.nvim`:

```lua
use {
  "metalelf0/git-utils",
  config = function()
    require("git-utils").setup({
      -- configuration options
    })
  end
}
```
