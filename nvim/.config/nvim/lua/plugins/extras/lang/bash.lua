return {
	-- shfmt is built-in to LazyVim, also tresitter is not needed for bash
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"bash-language-server",
				"shellcheck",
				"shfmt",
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				bashls = {},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				bash = { "shfmt" },
				sh = { "shfmt" },
				zsh = { "shfmt" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				bash = { "shellcheck" },
				sh = { "shellcheck" },
				zsh = { "shellcheck" },
			},
		},
	},
}
