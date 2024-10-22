local wezterm = require("wezterm")
local config = {}

local function getModelName()
	local empty_model = ""

	local handle = io.popen("system_profiler SPHardwareDataType | grep 'Model Name' | awk -F': ' '{print $2}'")
	if not handle then
		return empty_model
	end

	local read_result = handle:read("*a")
	if not read_result then
		return empty_model
	end

	handle:close()

	return read_result
end

local function getFontSizeBasedOnModelName()
	local font_size = 18
	local model_name = getModelName()

	if model_name:lower():find("macbook pro") then
		font_size = 16
	end

	return font_size
end

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.animation_fps = 75
config.audible_bell = "Disabled"
config.automatically_reload_config = true
config.color_scheme = "Tokyo Night"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 500
config.cursor_thickness = 0.7
config.default_cursor_style = "BlinkingBar"
config.default_cwd = wezterm.home_dir .. "/projects"
config.default_workspace = "projects"
config.enable_tab_bar = false
config.font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "Fira Code" })
config.font_size = getFontSizeBasedOnModelName()
config.hide_tab_bar_if_only_one_tab = true
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.macos_window_background_blur = 10
config.max_fps = 120
config.prefer_to_spawn_tabs = true
config.show_update_window = true
config.tab_bar_at_bottom = true
config.window_background_opacity = 0.95
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 5,
}

config:set_strict_mode(true)

return config
