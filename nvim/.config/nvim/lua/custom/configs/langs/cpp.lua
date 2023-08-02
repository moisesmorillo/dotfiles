local install_root_dir = vim.fn.stdpath "data" .. "/mason"
local extension_path = install_root_dir .. "/packages/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local ft = { "c", "cpp" }

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "clangd", "clang-format", "codelldb" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, ft)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = ft,
    opts = {
      servers = {
        clangd = {
          on_attach = function(client, bufnr)
            local lspconfig_on_attach = require("plugins.configs.lspconfig").on_attach

            client.server_capabilities.signatureHelpProvider = false
            lspconfig_on_attach(client, bufnr)
          end,
          filetypes = ft,
          root_dir = { "main.cpp", ".git" },
        },
      },
    },
  },

  {
    ft = ft,
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts.servers, {
        b.formatting.clang_format,
      })
    end,
  },

  {
    "mfussenegger/nvim-dap",
    ft = ft,
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
          dap.configurations.cpp = {
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

          dap.configurations.c = dap.configurations.cpp
        end,
      },
    },
  },

  {
    "danymat/neogen",
    ft = ft,
    opts = {
      languages = {
        c = {
          template = {
            annotation_convention = "doxygen",
          },
        },
        cpp = {
          template = {
            annotation_convention = "doxygen",
          },
        },
      },
    },
  },
}

return plugins
