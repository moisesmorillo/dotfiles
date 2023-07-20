local opt = vim.opt
local options = {
  colorcolumn = "120",
  modelines = 0,
  number = true,
  rnu = true,
  ruler = true,
  textwidth = 80,
  scrolloff = 8,
  showmatch = true,
  swapfile = false,
  fillchars = { eob = "~" },
}

-- better search
opt.path:remove "/usr/include"
opt.path:append "**"
opt.wildignorecase = true
opt.wildignore:append "**/node_modules/*"
opt.wildignore:append "**/.git/*"

for k, v in pairs(options) do
  opt[k] = v
end

local globals = {
  dap_virtual_text = true,
}

for k, v in pairs(globals) do
  vim.g[k] = v
end

-- Fix cursor block when exiting from neovim
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.cmd [[set guicursor=a:ver100]]
  end,
})
