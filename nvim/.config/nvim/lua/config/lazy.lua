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
		-- dap and testing
		{ import = "lazyvim.plugins.extras.dap.core" },
		{ import = "lazyvim.plugins.extras.test.core" },
		-- bash
		{ import = "plugins.extras.lang.bash" },
		-- c/c++
		{ import = "lazyvim.plugins.extras.lang.clangd" },
		{ import = "plugins.extras.lang.cpp" },
		-- docker
		{ import = "lazyvim.plugins.extras.lang.docker" },
		-- python
		-- TODO: Compare with https://github.com/moisesmorillo/dotfiles/blob/46ca5f2b716b5732c2d3c773d503a9a26fffc322/nvim/.config/nvim/lua/custom/configs/langs/python.lua
		-- go
		{ import = "lazyvim.plugins.extras.lang.go" },
		{ import = "plugins.extras.lang.go" },
		-- lua
		{ import = "lazyvim.plugins.extras.dap.nlua" },
		{ import = "plugins.extras.lang.lua" },
		-- markdown
		{ import = "lazyvim.plugins.extras.lang.markdown" },
		-- typescript
		{ import = "plugins.extras.lang.typescript" },
		-- rust
		-- TODO: Compare with https://github.com/moisesmorillo/dotfiles/blob/46ca5f2b716b5732c2d3c773d503a9a26fffc322/nvim/.config/nvim/lua/custom/configs/langs/rust.lua
		-- yaml
		-- TODO: add schemas https://github.com/moisesmorillo/dotfiles/blob/46ca5f2b716b5732c2d3c773d503a9a26fffc322/nvim/.config/nvim/lua/custom/configs/langs/yaml.lua#L38-L47
		{ import = "lazyvim.plugins.extras.lang.yaml" },
		{ import = "plugins.extras.lang.yaml" },
		-- coding
		{ import = "lazyvim.plugins.extras.coding.copilot" },
		-- linting and formatting
		{ import = "lazyvim.plugins.extras.linting.eslint" },
		{ import = "lazyvim.plugins.extras.formatting.prettier" },
		-- editor
		{ import = "lazyvim.plugins.extras.editor.aerial" },
		-- utils
		{ import = "lazyvim.plugins.extras.util.project" },
		-- local plugins
		{ import = "plugins" },
	},
	defaults = {
		lazy = true,
		version = false, -- always use the latest git commit
	},
	install = { colorscheme = { "tokyonight", "habamax" } },
	checker = { enabled = true }, -- automatically check for plugin updates
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
