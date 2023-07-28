local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local util = require "lspconfig.util"
local install_root_dir = vim.fn.stdpath "data" .. "/mason"
local extension_path = install_root_dir .. "/packages/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = "rust",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "rust-analyzer" })

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = "rust",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "rust" })

      return opts
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    ft = "rust",
    opts = function()
      local M = require "plugins.configs.cmp"
      vim.list_extend(M.sources, { name = "crates" })

      return M
    end,
  },

  {
    ft = "rust",
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts.servers, {
        b.formatting.clang_format,
      })

      return opts
    end,
  },

  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = {
      "rust-lang/rust.vim",
      "neovim/nvim-lspconfig",
    },
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
    opts = {
      servers = {
        rust_analyzer = {
          on_attach = on_attach,
          capabilities = capabilities,
          filetypes = { "rust" },
          root_dir = util.root_pattern("Cargo.toml", "Cargo.lock", ".git"),

          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = {
                command = "cargo clippy",
                extraArgs = { "--no-deps" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("rust-tools").setup {
        tools = {
          hover_actions = { border = "solid" },
          on_initialized = function()
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
              pattern = { "*.rs" },
              callback = function()
                vim.lsp.codelens.refresh()
              end,
            })
          end,
        },
        server = opts,
        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end,
  },

  {
    "mfussenegger/nvim-dap",
    opts = {
      setup = {
        codelldb = function()
          local dap = require "dap"
          dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
              command = codelldb_path,
              args = { "--port", "${port}" },
            },
          }
          dap.configurations.rust = {
            {
              name = "Launch file",
              type = "codelldb",
              request = "launch",
              program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
              stopOnEntry = false,
            },
          }
        end,
      },
    },
  },

  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      crates.show()
      require("core.utils").load_mappings "rust"
    end,
  },

  {
    "nvim-neotest/neotest",
    ft = "rust",
    dependencies = {
      "rouge8/neotest-rust",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, { require "neotest-rust" })

      return opts
    end,
  },
}

return plugins
