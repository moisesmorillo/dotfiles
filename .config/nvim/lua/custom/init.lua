local options = {
  colorcolumn = "80",
  modelines = 0,
  number = true,
  rnu = true,
  ruler = true,
  textwidth = 80,
  scrolloff = 8,
  showmatch = true,
  swapfile = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
