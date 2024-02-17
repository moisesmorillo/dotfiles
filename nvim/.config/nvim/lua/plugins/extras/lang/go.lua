return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			-- delve, gofumpt, gomodifytags, impl are already handled by lazynvim.plugins.extras.lang.go
			vim.list_extend(opts.ensure_installed, {
				"gofumpt",
				"golangci-lint",
				"golines",
				"gopls",
				"gotestsum",
				"iferr",
			})
		end,
	},
	-- TODO: test code actions before
	-- { "nvimtools/none-ls.nvim" },
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				go = { "golangcilint" },
			},
		},
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/neotest-go",
		},
		keys = {
			{
				"<leader>tT",
				function()
					require("neotest").run.run(vim.fn.getcwd())
				end,
				desc = "Run All Test Files",
			},
		},
		opts = {
			adapters = {
				["neotest-go"] = {
					experimental = {
						test_table = true,
					},
					recursive_run = true,
				},
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
		opts = {},
		event = { "CmdlineEnter" },
	},
}
