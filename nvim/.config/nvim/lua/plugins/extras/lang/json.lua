return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				jsonls = {
					settings = {
						validate = { enable = true },
					},
				},
			},
		},
	},
}
