return {
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
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/neotest-plenary",
		},
		opts = { adapters = { ["neotest-plenary"] = {} } },
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
