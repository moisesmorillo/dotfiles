---@type MappingsTable
local M = {}
local opts = {
  nowait = true,
  noremap = true,
  silent = true,
}

local opts_with_expr = vim.tbl_extend("force", opts, { expr = true })

M.disabled = {
  n = {
    ["<C-n>"] = "", -- Disable nvim-tree NvChad builtin
  },
}

M.general = {
  n = {
    ["<leader>q"] = { ":q<cr>", "Quit", opts = opts },
    ["<leader>pm"] = { "<cmd> Lazy <cr>", "Open Lazy Plugin Manager", opts = opts },
    -- Overwrite default Esc behavior to add silent execution to avoid noice
    -- plugin drawing this command
    ["<esc>"] = {
      "<cmd> :noh <cr>",
      "Clear highlights",
      opts = opts,
    },
    ["i"] = {
      function()
        if vim.fn.getline "." == "" then
          return [["_cc]]
        end

        return "i"
      end,
      "Fix identation in insert mode",
      opts = opts_with_expr,
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
    ["<leader>fl"] = { "<cmd>Telescope lazy<cr>", "Open Lazy Plugins in Telescope", opts = opts },
  },
}

M.nvimtree = {
  n = {
    ["<leader>e"] = { "<cmd> NvimTreeToggle <cr>", "Nvimtree (Explorer)", opts = opts },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = { "<cmd> DapToggleBreakpoint <cr>", "Toggle breakpoint", opts = opts },
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
      "Step back",
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
      "Step into",
      opts = opts,
    },
    ["<leader>dso"] = {
      function()
        require("dap").step_over()
      end,
      "Step over",
      opts = opts,
    },
    ["<leader>dsx"] = {
      function()
        require("dap").step_out()
      end,
      "Step out",
      opts = opts,
    },
  },
}

M.lazygit = {
  plugin = true,
  n = {
    ["<leader>lg"] = { "<cmd> LazyGit <cr>", "LazyGit", opts = opts },
  },
}

M.lspconfig = {
  n = {
    ["<leader>ra"] = { ":IncRename ", "LSP Rename", opts = opts },
    ["<leader>lspi"] = { "<cmd> LspInfo <cr>", "Open LSP Info", opts = opts },
    ["<leader>lspd"] = {
      "<cmd> Neoconf lsp <cr>",
      "Debug LSP Client",
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
    ["<leader>ttF"] = {
      function()
        require("neotest").run.run { vim.fn.expand "%", strategy = "dap" }
      end,
      "Debug Test File",
      opts = opts,
    },
    ["<leader>ttL"] = {
      function()
        require("neotest").run.run_last { strategy = "dap" }
      end,
      "Debug Last Test",
      opts = opts,
    },
    ["<leader>ttN"] = {
      function()
        require("neotest").run.run { strategy = "dap" }
      end,
      "Debug Nearest Test",
      opts = opts,
    },
    ["<leader>tts"] = {
      function()
        require("neotest").run.stop()
      end,
      "Stop",
      opts = opts,
    },
    ["<leader>ttS"] = {
      function()
        require("neotest").summary.toggle()
      end,
      "Summary",
      opts = opts,
    },
    ["<leader>tta"] = {
      function()
        require("neotest").summary.attach()
      end,
      "Attach",
      opts = opts,
    },
    ["<leader>ttf"] = {
      function()
        require("neotest").run.run(vim.fn.expand "%")
      end,
      "Test File",
      opts = opts,
    },
    ["<leader>ttl"] = {
      function()
        require("neotest").run.run_last()
      end,
      "Test Last",
      opts = opts,
    },
    ["<leader>ttn"] = {
      function()
        require("neotest").run.run()
      end,
      "Test Nearest",
      opts = opts,
    },
    ["<leader>tto"] = {
      function()
        require("neotest").output.open { enter = true }
      end,
      "Output",
      opts = opts,
    },
    ["<leader>ttz"] = {
      function()
        require("neotest").run.run { vim.fn.getcwd() }
      end,
      "Suite",
      opts = opts,
    },
  },
}

M.overseer = {
  plugin = true,
  n = {
    ["<leader>trR"] = { "<cmd>OverseerRunCmd<cr>", "Run Command", opts = opts },
    ["<leader>tra"] = { "<cmd>OverseerTaskAction<cr>", "Task Action", opts = opts },
    ["<leader>trb"] = { "<cmd>OverseerBuild<cr>", "Build", opts = opts },
    ["<leader>trc"] = { "<cmd>OverseerClose<cr>", "Close", opts = opts },
    ["<leader>trd"] = { "<cmd>OverseerDeleteBundle<cr>", "Delete Bundle", opts = opts },
    ["<leader>trl"] = { "<cmd>OverseerLoadBundle<cr>", "Load Bundle", opts = opts },
    ["<leader>tro"] = { "<cmd>OverseerOpen<cr>", "Open", opts = opts },
    ["<leader>trq"] = { "<cmd>OverseerQuickAction<cr>", "Quick Action", opts = opts },
    ["<leader>trr"] = { "<cmd>OverseerRun<cr>", "Run", opts = opts },
    ["<leader>trs"] = { "<cmd>OverseerSaveBundle<cr>", "Save Bundle", opts = opts },
    ["<leader>trt"] = { "<cmd>OverseerToggle<cr>", "Toggle", opts = opts },
  },
}

M.neogen = {
  plugin = true,
  n = {
    ["<leader>cgd"] = {
      function()
        require("neogen").generate()
      end,
      "Annotation",
      opts = opts,
    },
    ["<leader>cgc"] = {
      function()
        require("neogen").generate { type = "class" }
      end,
      "Class Annotation",
      opts = opts,
    },
    ["<leader>cgf"] = {
      function()
        require("neogen").generate { type = "func" }
      end,
      "Function Annotation",
      opts = opts,
    },
    ["<leader>cgt"] = {
      function()
        require("neogen").generate { type = "type" }
      end,
      "Type Annotation",
      opts = opts,
    },
  },
}

M.refactoring = {
  plugin = true,
  v = {
    ["<leader>rr"] = {
      function()
        require("telescope").extensions.refactoring.refactors()
      end,
      "Refactoring",
      opts = opts,
    },
  },
}

M.todo = {
  plugin = true,
  n = {
    ["[t"] = {
      function()
        require("todo-comments").jump_prev()
      end,
      "Previous TODO",
      opts = opts,
    },
    ["]t"] = {
      function()
        require("todo-comments").jump_next()
      end,
      "Next TODO",
      opts = opts,
    },
    ["<leader>ct"] = { "<cmd>TodoTelescope<cr>", "Open TODO in Telescope", opts = opts },
    ["<leader>cT"] = { "<cmd>TodoTrouble<cr>", "Open TODO in Trouble", opts = opts },
  },
}

M.markdown = {
  plugin = true,
  n = {
    ["<leader>mp"] = { "<cmd> MarkdownPreviewToggle <cr>", "Markdown Preview Toggle", opts = opts },
  },
}

M.navbuddy = {
  plugin = true,
  n = {
    ["<leader>vO"] = {
      function()
        require("nvim-navbuddy").open()
      end,
      "Code Outline (navbuddy)",
      opts = opts,
    },
  },
}

M.codeium = {
  plugin = true,
  i = {
    ["<A-CR>"] = {
      function()
        return vim.fn["codeium#Accept"]()
      end,
      "Codeium Accept Suggestion",
      opts = opts_with_expr,
    },
    ["<C-[>"] = {
      function()
        return vim.fn["codeium#CycleCompletions"](1)
      end,
      "Codeium Next Suggestion",
      opts = opts_with_expr,
    },
    ["<C-]>"] = {
      function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end,
      "Codeium Previous Suggestion",
      opts = opts_with_expr,
    },
    ["<Esc>"] = {
      function()
        return vim.fn["codeium#Clear"]()
      end,
      "Codeium Clear Suggestion",
      opts = opts_with_expr,
    },
  },
}

M.wtf = {
  plugin = true,
  n = {
    ["<leader>sd"] = {
      function()
        require("wtf").ai()
      end,
      "Search Diagnostic with AI",
      opts = opts,
    },
    ["<leader>sD"] = {
      function()
        require("wtf").search()
      end,
      "Search Diagnostic with Google",
      opts = opts,
    },
  },
}

return M
