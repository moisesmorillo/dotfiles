local ok, catppuccin = pcall(require, "catppuccin")

if ok then
  catppuccin.setup({
    flavour = "mocha",
  })
  
  vim.cmd.colorscheme("catppuccin")
else
  print("Module catppuccin not found")
end
