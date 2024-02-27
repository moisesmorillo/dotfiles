-- This also has an autocmd in nvim/.config/nvim/lua/config/autocmds.lua which set Jenkinsfile to groovy filetype.
return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "groovy" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				groovyls = {},
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				groovy = { "npm-groovy-lint" },
			},
			linters = {
				["npm-groovy-lint"] = {
					args = { "--failon", "error" },
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			formatters_by_ft = {
				groovy = { "npm_groovy_lint" },
			},
			formatters = {
				npm_groovy_lint = {
					command = "npm-groovy-lint",
					args = { "--failon", "error", "--fix", "$FILENAME" },
					cwd = require("conform.util").root_file({ ".git" }),
					stdin = false,
				},
			},
		},
	},
}
