local utils = require("core.utils")
local ok, tree = pcall(require, "nvim-tree")
if not ok then return false end

tree.setup({
  actions = {
    open_file = {
      quit_on_open = true,
    }
  },
  diagnostics = {
    enable = true,
    icons = {
      error = "",
      hint = "",
      info = "",
      warning = "",
    }
  },
  git = {
    enable = true,
    ignore = false,
  },
  filters = {
    custom = { '^\\.git', '^node_modules$', '^\\.DS_Store$' },
  },
  hijack_cursor = true,
  hijack_directories = {
    auto_open = true,
    enable = true,
  },
  modified = {
    enable = true,
  },
  renderer = {
    special_files = {
      "Cargo.toml", "Makefile", "README.md", "readme.md", "wrangler.toml",
      "package.json", "go.mod", "go.sum", "sonar-project.properties"
    },
    highlight_git = true,
    group_empty = true,
    highlight_opened_files = "all",
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
  view = {
    adaptive_size = true,
    side = "right",
    width = "25%",
  },
})

-- Open/Quit NvimTree
utils.nnoremap("<leader>e", ":NvimTreeToggle<cr>")
