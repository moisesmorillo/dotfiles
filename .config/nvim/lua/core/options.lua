-- Before setting up new options, review defaults :h nvim-defaults
local options = {
  autowrite = true,
  backup = false,
  clipboard = "unnamedplus",
  cmdheight = 2,
  colorcolumn = "80",
  expandtab = true,
  errorbells = false,
  fileformat = "unix",
  formatoptions = "tcqrn1",
  ignorecase = true,
  history = 1000,
  modelines = 0,
  number = true,
  rnu = true,
  ruler = true,
  tabstop = 2,
  termguicolors = true,
  textwidth = 80,
  scrolloff = 8,
  shiftwidth = 2,
  showmatch = true,
  signcolumn = "yes",
  smartcase = true,
  softtabstop = 2,
  swapfile = false,
  wildmode = "longest:full,list:full",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
