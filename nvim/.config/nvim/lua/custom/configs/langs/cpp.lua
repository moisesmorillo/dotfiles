local install_root_dir = vim.fn.stdpath "data" .. "/mason"
local extension_path = install_root_dir .. "/packages/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = { "c", "cpp" },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "clangd", "clang-format", "codelldb" })

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = { "c", "cpp" },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "c", "cpp" })

      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = { "c", "cpp" },
    opts = {
      servers = {
        clangd = {
          on_attach = function(client, bufnr)
            local lspconfig_on_attach = require("plugins.configs.lspconfig").on_attach

            client.server_capabilities.signatureHelpProvider = false
            lspconfig_on_attach(client, bufnr)
          end,
          filetypes = { "c", "cpp" },
          root_dir = { "main.cpp", ".git" },
        },
      },
    },
  },

  {
    ft = { "c", "cpp" },
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
    "mfussenegger/nvim-dap",
    ft = { "c", "cpp" },
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
    ft = { "c", "cpp" },
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
