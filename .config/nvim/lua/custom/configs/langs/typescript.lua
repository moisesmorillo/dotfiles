local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

lspconfig.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	root_dir = util.root_pattern("package.json", "yarn.lock", "package-lock.json", ".git"),
})
