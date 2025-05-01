local opt = vim.opt
local options = {
  colorcolumn = "120",
  expandtab = true,
  fillchars = { eob = "~" },
  listchars = { tab = "  " },
  modelines = 0,
  number = true,
  rnu = true,
  ruler = true,
  scrolloff = 8,
  shiftwidth = 2,
  showmatch = true,
  softtabstop = 2,
  swapfile = false,
  tabstop = 2,
  textwidth = 120,
  -- winborder = "rounded",
}

-- better search
opt.path:remove("/usr/include")
opt.path:append("**")
opt.wildignorecase = true
opt.wildignore:append("**/node_modules/*")
opt.wildignore:append("**/.git/*")

for k, v in pairs(options) do
  opt[k] = v
end

local globals = {
  dap_virtual_text = true,
}

for k, v in pairs(globals) do
  vim.g[k] = v
end

-- LazyVim Customizations
vim.g.lazyvim_statuscolumn = {
  folds_open = true, -- show fold sign when fold is open
  folds_githl = true, -- highlight fold sign with git sign color
}

vim.g.lazyvim_python_ruff = "ruff"
vim.g.lazyvim_python_lsp = "basedpyright"
