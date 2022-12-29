require("bufferline").setup({
  options = {
    max_name_length = 25,
    tab_size = 25,
    diagnostics = "coc",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      }
    }
  }
})
