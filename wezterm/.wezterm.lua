local wezterm = require("wezterm")

return {
	animation_fps = 100,
	audible_bell = "Disabled",
	color_scheme = "Catppuccin Mocha",
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	cursor_blink_rate = 500,
	cursor_thickness = 0.7,
	default_cursor_style = "BlinkingBar",
	font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "Fira Code" }),
	font_size = 18,
	window_background_opacity = 0.96,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}
