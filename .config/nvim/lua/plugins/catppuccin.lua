local opts = {
  flavour = "mocha",
  integrations = {
    nvimtree = true,
    fidget = true,
  },
  transparent_background = true,
  show_end_of_buffer = true,
}

return {
  "catppuccin/nvim",
  name = "catppuccin",
  event = "VimEnter",
  opts = opts,
  init = function ()
    vim.cmd([[colorscheme catppuccin]])
  end,
}
