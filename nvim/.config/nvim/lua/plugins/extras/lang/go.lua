-- Using lazyvim.plugins.extras.lang.go + personal setup
return {
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
		event = { "CmdlineEnter" }, -- TODO: better handler
		build = ":lua require(\"go.install\").update_all_sync()", -- if you need to install/update all binaries
	},
}
