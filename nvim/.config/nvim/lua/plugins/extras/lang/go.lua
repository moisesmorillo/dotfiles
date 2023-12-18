-- Using lazyvim.plugins.extras.lang.go + personal setup
return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"delve",
				"gofumpt",
				"golangci-lint",
				"golangci-lint-langserver",
				"golines",
				"gopls",
				"gotestsum",
				"iferr",
				"impl",
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				golangci_lint_ls = {},
			},
		},
	},
	{
		"danymat/neogen",
		opts = function(_, opts)
			opts = vim.tbl_deep_extend("force", opts or {}, {
				languages = {
					go = {
						template = {
							annotation_convention = "godoc",
						},
					},
				},
			})
			return opts
		end,
	},
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { "go", "gomod" },
		opts = {},
		event = { "CmdlineEnter" },
	},
}
