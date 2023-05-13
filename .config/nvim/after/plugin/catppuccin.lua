local ok, catppuccin = pcall(require, "catppuccin")
if not ok then return false end

catppuccin.setup({
  flavour = "mocha",
})

vim.cmd.colorscheme("catppuccin")
