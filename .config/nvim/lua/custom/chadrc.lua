---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.ui = {
	theme = "catppuccin",
	theme_toggle = { "catppuccin", "one_light" },
	statusline = {
		theme = "vscode_colored",
		separator_style = "round",
		overriden_modules = function()
			return {
				LSP_progress = function()
					return ""
				end,
			}
		end,
	},

	hl_override = highlights.override,
	hl_add = highlights.add,

	nvdash = {
		load_on_startup = true,
	},
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
