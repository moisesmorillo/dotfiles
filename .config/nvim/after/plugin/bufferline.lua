local ok, bufferline = pcall(require, "bufferline")

if ok then
  bufferline.setup({
    options = {
      mode = "buffers",
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
else
  print("Module bufferline not found")
end
