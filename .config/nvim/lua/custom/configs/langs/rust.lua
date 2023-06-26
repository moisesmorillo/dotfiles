local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local util = require("lspconfig/util")

local options = {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "rust" },
	root_dir = util.root_pattern("Cargo.toml", "Cargo.lock", ".git"),
}

return options
