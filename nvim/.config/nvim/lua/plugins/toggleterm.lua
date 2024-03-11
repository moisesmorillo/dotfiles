return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{
			"<f1>",
			function()
				require("toggleterm").toggle_command("direction='vertical'")
			end,
			desc = "Toggle Terminal Vertical",
		},
	},
	opts = {
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.3
			end
		end,
	},
}
