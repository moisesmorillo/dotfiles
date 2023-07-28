---@type ChadrcConfig
local M = {}

local highlights = require "custom.highlights"

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

  tabufline = {
    lazyload = false,
  },

  hl_override = highlights.override,
  hl_add = highlights.add,

  nvdash = {
    load_on_startup = true,
  },

  cmp = {
    style = "atom",
  },
}

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

return M
