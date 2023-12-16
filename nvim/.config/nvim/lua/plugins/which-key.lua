return {
	"folke/which-key.nvim",
	opts = function(_, opts)
		opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
			["<leader>cl"] = { name = "+lsp" },
		})
		return opts
	end,
}
