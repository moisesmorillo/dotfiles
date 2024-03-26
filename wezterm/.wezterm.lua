local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.9

-- config.font = wezterm.font("JetBrainsMono", { weight = "Regular", style = "Regular" })
config.font_size = 18

return config
