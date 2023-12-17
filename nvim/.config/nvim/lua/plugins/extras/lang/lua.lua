return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"lua",
				"luadoc",
				"luap",
				"vim",
				"vimdoc",
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"lua-language-server",
				"stylua",
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							codeLens = {
								enable = true,
							},
							completion = {
								autoRequire = true,
								enable = true,
								callSnippet = "Both",
								displayContext = true,
								showParams = true,
							},
							diagnostics = {
								enable = true,
								globals = { "vim" },
								workspaceDelay = 100,
							},
							hint = {
								enable = true,
								paramName = "all",
							},
							workspace = {
								checkThirdParty = false,
								maxPreload = 100000,
								preloadFileSize = 10000,
							},
						},
					},
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = {
				lua = { "stylua" },
			}
			return opts
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/neotest-plenary",
		},
		opts = function(_, opts)
			vim.list_extend(opts.adapters, {
				require("neotest-plenary"),
			})
		end,
	},
	{
		"danymat/neogen",
		opts = function(_, opts)
			opts = vim.tbl_deep_extend("force", opts or {}, {
				languages = {
					lua = {
						template = {
							annotation_convention = "ldoc",
						},
					},
				},
			})
			return opts
		end,
	},
}
