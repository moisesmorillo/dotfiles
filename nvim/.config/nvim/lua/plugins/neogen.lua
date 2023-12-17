return {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	keys = {
		{
			"<leader>cga",
			function()
				require("neogen").generate()
			end,
			desc = "General Annotation",
		},
		{
			"<leader>cgc",
			function()
				require("neogen").generate({ type = "class" })
			end,
			desc = "Class Annotation",
		},
		{
			"<leader>cgf",
			function()
				require("neogen").generate({ type = "func" })
			end,
			desc = "Function Annotation",
		},
		{
			"<leader>cgt",
			function()
				require("neogen").generate({ type = "type" })
			end,
			desc = "Type Annotation",
		},
	},
	opts = {
		enabled = true,
		languages = {},
		snippet_engine = "luasnip",
	},
}
