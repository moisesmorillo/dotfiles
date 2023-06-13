local opts = {
  disable_netrw = true,
  hijack_netrw = true,
  respect_buf_cwd = true,
  sync_root_with_cwd = true,
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
    float = {
      enable = true,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * 0.5
        local window_h = screen_h * 0.75
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get() - 2

        return {
          border = "rounded",
          relative = "editor",
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
      end,
    },
  },
  update_focused_file = {
    enable = true,
  },
}

local keys = {
  {"<leader>e", ":NvimTreeToggle<cr>", desc = "NvimTree: Toggle", silent = true, noremap = true},
}

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = opts,
  keys = keys,
  version = "nightly"
}
