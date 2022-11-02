require("nvim-tree").setup({
  open_on_setup = true,
  diagnostics = {
    enable = true,
  },
  view = {
    adaptive_size = true,
    width = "25%",
  },
  renderer = {
    highlight_git = true,
    icons = {
      glyphs = {
        folder = {
          arrow_closed = "+",
          arrow_open = "-"
        }
      }
    },
  },
})
