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
    ["<leader>lspi"] = { "<cmd> LspInfo <CR>", "Open LSP Info", opts = opts },
    ["<leader>lspd"] = {
      function()
        local clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
        if next(clients) == nil then
          return ""
        end

        local client_list = {}
        for _, client in pairs(clients) do
          table.insert(client_list, client.name)
        end

        vim.ui.select(client_list, {
          prompt_title = "Select LSP Server",
        }, function(input)
          local new_buffer = vim.api.nvim_create_buf(false, true)
          local content = vim.inspect(vim.lsp.get_active_clients { name = input })
          vim.api.nvim_buf_set_lines(new_buffer, 0, -1, true, vim.split(content, "\n"))
          vim.api.nvim_set_current_buf(new_buffer)
        end)
      end,
      "Debug Attached LSP Client",
      opts = opts,
    },
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

M.neotest = {
  plugin = true,
  n = {
    ["<leader>tNF"] = {
      function()
        require("neotest").run.run { vim.fn.expand "%", strategy = "dap" }
      end,
      "Neotest Debug Test File",
      opts = opts,
    },
    ["<leader>tNL"] = {
      function()
        require("neotest").run.run_last { strategy = "dap" }
      end,
      "Neotest Debug Last Test",
      opts = opts,
    },
    ["<leader>tNN"] = {
      function()
        require("neotest").run.run { strategy = "dap" }
      end,
      "Neotest Debug Nearest Test",
      opts = opts,
    },
    ["<leader>tNs"] = {
      function()
        require("neotest").run.stop()
      end,
      "Neotest Stop",
      opts = opts,
    },
    ["<leader>tNS"] = {
      function()
        require("neotest").summary.toggle()
      end,
      "Neotest Summary",
      opts = opts,
    },
    ["<leader>tNa"] = {
      function()
        require("neotest").summary.attach()
      end,
      "Neotest Attach",
      opts = opts,
    },
    ["<leader>tNf"] = {
      function()
        require("neotest").run.run(vim.fn.expand "%")
      end,
      "Neotest Test File",
      opts = opts,
    },
    ["<leader>tNl"] = {
      function()
        require("neotest").run.run_last()
      end,
      "Neotest Test Last",
      opts = opts,
    },
    ["<leader>tNn"] = {
      function()
        require("neotest").run.run()
      end,
      "Neotest Test Nearest",
      opts = opts,
    },
    ["<leader>tNo"] = {
      function()
        require("neotest").output.open { enter = true }
      end,
      "Neotest Output",
      opts = opts,
    },
  },
}

M.overseer = {
  plugin = true,
  n = {
    ["<leader>toR"] = { "<cmd>OverseerRunCmd<CR>", "Overseer Run Command", opts = opts },
    ["<leader>to"] = { "<cmd>OverseerTaskAction<CR>", "Overseer Task Action", opts = opts },
    ["<leader>tob"] = { "<cmd>OverseerBuild<CR>", "Overseer Build", opts = opts },
    ["<leader>toc"] = { "<cmd>OverseerClose<CR>", "Overseer Close", opts = opts },
    ["<leader>tod"] = { "<cmd>OverseerDeleteBundle<CR>", "Overseer Delete Bundle", opts = opts },
    ["<leader>tol"] = { "<cmd>OverseerLoadBundle<cr>", "Overseer Load Bundle", opts = opts },
    ["<leader>too"] = { "<cmd>OverseerOpen<cr>", "Overseer Open", opts = opts },
    ["<leader>toq"] = { "<cmd>OverseerQuickAction<cr>", "Overseer Quick Action", opts = opts },
    ["<leader>tor"] = { "<cmd>OverseerRun<cr>", "Overseer Run", opts = opts },
    ["<leader>tos"] = { "<cmd>OverseerSaveBundle<cr>", "Overseer Save Bundle", opts = opts },
    ["<leader>tot"] = { "<cmd>OverseerToggle<cr>", "Overseer Toggle", opts = opts },
  },
}

return M
