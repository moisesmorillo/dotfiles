local ok, lualine = pcall(require, "lualine")

if ok then
  lualine.setup({
    options = {
      disabled_filetypes = { "packer", "NvimTree" },
    }
  })
else
  print("Module lualine not found")
end

