return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{
			"<f1>",
			function()
				require("toggleterm").toggle_command("direction='horizontal'")
			end,
			desc = "Toggle Terminal Horizontal",
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
