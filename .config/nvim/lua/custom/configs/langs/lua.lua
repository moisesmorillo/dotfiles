local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
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
				workspaceDelay = 500,
			},
			hint = {
				enable = true,
				paramName = "all",
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					[vim.fn.stdpath("data") .. "/lazy/extensions/nvchad_types"] = true,
					[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
				},
				checkThirdParty = false,
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
		},
	},
})
