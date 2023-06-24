local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- lua lsp stuff
lspconfig.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,

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

-- TODO golang stuff
--[[ return {
  event = { "BufReadPre", "BufNewFile" },
  "neovim/nvim-lspconfig",
  init = function()
    local options = {
      go_highlight_build_constraints = 1,
      go_highlight_extra_types = 1,
      go_highlight_fields = 1,
      go_highlight_functions = 1,
      go_highlight_methods = 1,
      go_highlight_operators = 1,
      go_highlight_structs = 1,
      go_highlight_types = 1,
      go_auto_sameids = 1,
      go_fmt_command = "goimports",
      go_auto_type_info = 1,
      go_textobj_include_function_doc = 0,
      go_highlight_function_calls = 1,
      go_highlight_generate_tag = 1,
      go_def_mode = "gopls",
      go_info_mode = "gopls",
    }
    for k, v in pairs(options) do
      vim.g[k] = v
    end
    vim.cmd [[
    autocmd FileType go nnoremap <leader>gb <plug>(go-build)
    autocmd FileType go nnoremap <leader>gr <plug>(go-run)
    autocmd FileType go nnoremap <leader>gt :GoTest ./...<cr>
    autocmd FileType go nnoremap <leader>gtf <plug>(go-test-func)
    autocmd FileType go nnoremap <leader>gc <plug>(go-coverage-toggle)
    autocmd FileType go nnoremap <c-n> :cnext<cr>
    autocmd FileType go nnoremap <c-p> :cprevious<cr>
    autocmd FileType go nnoremap <c-a> :cclose<cr>
    ]]
--end,
--opts = {},
--}
