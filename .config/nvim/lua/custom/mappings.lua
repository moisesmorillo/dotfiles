---@diagnostic disable: missing-fields
---@type MappingsTable
local M = {}
local opts = {
  nowait = true,
  noremap = true,
  silent = true,
}

M.disabled = {
  n = {
    ["<C-n>"] = "",
  },
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = opts },
    ["<leader>q"] = { ":q<cr>", "Quit", opts = opts },
    ["<leader>pm"] = { "<cmd> Lazy <CR>", "Open Lazy Plugin Manager", opts = opts },
    ["<leader>li"] = { "<cmd> LspInfo <CR>", "Open LSP Info", opts = opts },
    -- Overwrite default Esc behavior to add silent execution to avoid noice
    -- plugin drawing this command
    ["<Esc>"] = {
      "<cmd> :noh <CR>",
      "Clear highlights",
      opts = opts,
    },
  },
}

M.telescope = {
  plugin = true,
  n = {
    ["<leader>fd"] = {
      function()
        require("telescope.builtin").git_files {
          prompt_title = "<Dotfiles>",
          cwd = "~/projects/dotfiles/",
        }
      end,
      "Open dotfiles",
      opts = opts,
    },
    ["<leader>fs"] = {
      function()
        require("telescope.builtin").symbols {
          sources = { "emoji", "kaomoji", "gitmoji" },
        }
      end,
      "Open emojis",
      opts = opts,
    },
    ["<leader>fp"] = {
      function()
        require("telescope").extensions.project.project {}
      end,
      "Open projects",
      opts = opts,
    },
  },
}

M.nvimtree = {
  n = {
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree", opts = opts },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>", "Toggle breakpoint", opts = opts },
    ["<leader>du"] = {
      function()
        require("dapui").toggle()
      end,
      "Toggle UI",
      opts = opts,
    },
    ["<leader>dsb"] = {
      function()
        require("dap").step_back()
      end,
      "Step Back",
      opts = opts,
    },
    ["<leader>ds"] = {
      function()
        require("dap").continue()
      end,
      "Start/Continue",
      opts = opts,
    },
    ["<leader>dsi"] = {
      function()
        require("dap").step_into()
      end,
      "Step Into",
      opts = opts,
    },
    ["<leader>dso"] = {
      function()
        require("dap").step_over()
      end,
      "Step Over",
      opts = opts,
    },
    ["<leader>dsx"] = {
      function()
        require("dap").step_out()
      end,
      "Step Out",
      opts = opts,
    },
  },
}

M.lazygit = {
  plugin = true,
  n = {
    ["<leader>lg"] = { "<cmd> LazyGit <CR>", "Open LazyGit", opts = opts },
  },
}

M.lspconfig = {
  n = {
    ["<leader>ra"] = { ":IncRename ", "LSP Rename", opts = opts },
  },
}

M.rust = {
  plugin = true,
  n = {
    ["<leader>rcu"] = {
      function()
        require("crates").upgrade_all_crates()
      end,
      "Update crates",
      opts = opts,
    },
  },
}

M.go = {
  plugin = true,
  n = {
    -- TODO add more debug methods for go
    ["<leader>dgt"] = {
      function()
        require("dap-go").debug_test()
      end,
      "Debug go test",
      opts = opts,
    },
  },
}

M.python = {
  plugin = true,
  n = {
    -- TODO add more debug methods for python
    ["<leader>dpt"] = {
      function()
        require("dap-python").test_method()
      end,
      "Debung python test",
      opts = opts,
    },
  },
}

return M
