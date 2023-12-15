return {
	"neovim/nvim-lspconfig",
	ft = { "lua" },
	opts = {
		servers = {
			lua_ls = {
				filetypes = { "lua" },
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
}
