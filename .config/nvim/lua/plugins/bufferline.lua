local opts = {
  mode = "buffers",
  themable = true,
  numbers = "none",
  max_name_length = 25,
  indicator = {
    style = "underline",
  },
  buffer_close_icon = '',
  modified_icon = '',
  tab_size = 20,
  diagnostics = "nvim_lsp",
  show_buffer_icons = true,
  separator_style = {"any", ""},
  always_show_bufferline = true,
  offsets = {
    {
      filetype = "NvimTree",
      text = "Explorer",
      highlight = "Directory",
      text_align = "left",
      padding = -1,
    },
  },
}

return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VimEnter",
  config = function()
    require("bufferline").setup({
      options = opts,
      highlights = require("catppuccin.groups.integrations.bufferline").get()
    })
  end
}
