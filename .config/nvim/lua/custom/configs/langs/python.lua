local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

local get_poetry_venv_path = function()
	local fn = vim.fn
	return fn.trim(fn.system("poetry config virtualenvs.path"))
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
