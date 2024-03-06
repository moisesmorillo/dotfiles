return {
	"folke/edgy.nvim",
	opts = function(_, opts)
		-- Swap the left and right sides, and leave the right side empty for NeoTree
		opts.left = opts.right or {}
		opts.right = {}

		vim.list_extend(opts.left, {
			{
				title = "Neotest Summary",
				ft = "neotest-summary",
				size = { width = 0.4 },
			},
		})

		vim.list_extend(opts.bottom, {
			{
				title = "Neotest Output",
				ft = "neotest-output",
			},
		})

		vim.print(vim.inspect(opts.bottom))

		return opts
	end,
}
