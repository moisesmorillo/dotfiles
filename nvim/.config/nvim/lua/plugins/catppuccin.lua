return {
	"catppuccin/nvim",
	name = "catppuccin",
	opts = {
		flavour = "mocha",
		transparent_background = true,
		custom_highlights = function(colors)
			return {
				NormalFloat = { bg = colors.surface0 },
			}
		end,
	},
}
