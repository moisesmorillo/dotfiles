local ok, lualine = pcall(require, "lualine")
if not ok then return false end

lualine.setup({
  options = {
    disabled_filetypes = { "packer", "NvimTree" },
  }
})
