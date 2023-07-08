local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {
	-- webdev stuff
	b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
	b.formatting.prettier.with({ filetypes = { "html", "markdown", "css" } }), -- so prettier works only on these filetypes

	-- lua stuff
	b.formatting.stylua,

	-- cpp/c stuff
	b.formatting.clang_format,

	-- go stuff
	b.formatting.gofumpt,
	b.formatting.goimports_reviser.with({
		extra_args = { "-set-alias", "-rm-unused" },
	}),
	b.formatting.golines.with({
		extra_args = { "-m", "120" },
	}),

	-- python stuff
	b.formatting.black,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end
end

null_ls.setup({
	debug = true,
	sources = sources,
	on_attach = on_attach,
})
