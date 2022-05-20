require('nightfox').setup({
  options = {
    styles = {
      commnets = "italic",
      keywords = "italic,bold",
      types = "italic,bold",
      variables = "bold",
    }
  }
})

vim.cmd('colorscheme nightfox')
