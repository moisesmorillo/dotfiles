---@diagnostic disable: missing-fields
---@type LazySpec
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = {
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
    explorer = {
      replace_netrw = true,
    },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          layout = { layout = { position = "right" } },
        },
      },
    },
    lazygit = {
      configure = true,
    },
  },
}
