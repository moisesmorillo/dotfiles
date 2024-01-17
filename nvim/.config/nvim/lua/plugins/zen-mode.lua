return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	opts = {
		plugins = {
			alacritty = {
				enabled = true,
				font = "24",
			},
			options = {
				laststatus = 0,
			},
			tmux = { enabled = true },
		},
		on_open = function(_)
			require("barbecue.ui").toggle(false)
		end,
		on_close = function(_)
			require("barbecue.ui").toggle(true)
		end,
	},
}
