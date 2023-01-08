require("nvim-tree").setup({
  diagnostics = {
    enable = true,
  },
  view = {
    adaptive_size = true,
    width = "25%",
    side = "right",
 },
 modified = {
   enable = true,
 },
  renderer = {
    highlight_git = true,
    highlight_modified = "all",
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        modified = true,
      },
      glyphs = {
        folder = {
          arrow_closed = "+",
          arrow_open = "-"
        }
      }
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
    }
  }
})
