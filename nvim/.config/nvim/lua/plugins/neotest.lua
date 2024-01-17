return {
	"nvim-neotest/neotest",
	dependencies = {
		"stevearc/overseer.nvim",
	},
	opts = function(_, opts)
		opts.consumers = opts.consumers or {}
		opts.consumers.overseer = require("neotest.consumers.overseer")
		opts.overseer = {
			enabled = true,
			force_default = true,
		}
	end,
}
