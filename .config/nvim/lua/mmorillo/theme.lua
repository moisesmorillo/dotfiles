require("nightfox").setup({
  options = {
    styles = {
      comments = "italic",
      keywords = "italic",
    },
    transparent = true,
  },
  palettes = {
    carbonfox = {
      sel0 = "#035c7c",
    },
  },
})
vim.cmd("colorscheme carbonfox")
