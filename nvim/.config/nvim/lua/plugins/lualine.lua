---@type LazySpec
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, 2, { require("mcphub.extensions.lualine") })
  end,
}
