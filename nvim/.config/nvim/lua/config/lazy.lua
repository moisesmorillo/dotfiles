local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		-- bash
		{ import = "plugins.extras.lang.bash" },
		-- c/cpp
		{ import = "plugins.extras.lang.cpp" },
		-- go
		{ import = "plugins.extras.lang.go" },
		-- lua
		{ import = "plugins.extras.lang.lua" },
		-- python
		{ import = "plugins.extras.lang.python" },
		-- rust
		{ import = "plugins.extras.lang.rust" },
		-- typescript
		{ import = "plugins.extras.lang.typescript" },
		-- yaml
		{ import = "plugins.extras.lang.yaml" },
		-- local plugins
		{ import = "plugins" },
	},
	defaults = {
		lazy = true,
		version = false, -- always use the latest git commit
	},
	install = { colorscheme = { "tokyonight", "habamax" } },
	checker = { enabled = false }, -- automatically check for plugin updates
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
