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
          layout = {
            layout = {
              backdrop = false,
              width = 40,
              min_width = 40,
              height = 0,
              position = "right",
              border = "none",
              box = "vertical",
              {
                win = "input",
                height = 1,
                border = "solid",
              },
              {
                win = "list",
                border = "none",
              },
            },
          },
        },
      },
    },
    lazygit = {
      configure = true,
    },
    indent = { enabled = false },
  },
}
