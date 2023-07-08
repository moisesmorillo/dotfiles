local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

local get_poetry_venv_path = function()
	local fn = vim.fn
	if fn.executable("poetry") == 1 then
		return fn.trim(fn.system("poetry config virtualenvs.path"))
	end

	return ""
end

lspconfig.pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "python" },
	root_dir = util.root_pattern("requirements.txt", "pyproject.toml", "poetry.lock", ".git"),

	settings = {
		pyright = {
			venvPath = get_poetry_venv_path(),
		},
	},
})

lspconfig.ruff_lsp.setup({
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		-- Disable hover in favor of Pyright
		client.server_capabilities.hoverProvider = false
	end,
	capabilities = capabilities,
	filetypes = { "python" },
	root_dir = util.root_pattern("requirements.txt", "pyproject.toml", "poetry.lock", ".git"),
})
