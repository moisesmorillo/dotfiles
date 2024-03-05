return {
	"folke/edgy.nvim",
	opts = function(_, opts)
		-- Swap the left and right sides, and leave the right side empty for NeoTree
		opts.left = opts.right
		opts.right = {}

		return opts
	end,
}
