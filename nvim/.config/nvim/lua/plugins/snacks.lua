---@type LazySpec
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    ---@class snacks.explorer.Config
    explorer = {
      replace_netrw = true,
    },
    picker = {
      sources = {
        ---@class snacks.picker.explorer.Config
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
