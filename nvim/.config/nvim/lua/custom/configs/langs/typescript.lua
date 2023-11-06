local ft = { "typescript", "javascript" }

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(
        opts.ensure_installed,
        { "typescript-language-server", "prettierd", "deno", "js-debug-adapter", "eslint-lsp" }
      )
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "typescript", "javascript" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = ft,
    opts = {
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = "auto" },
          },
        },
      },
    },
  },

  {
    "pmizio/typescript-tools.nvim",
    ft = ft,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = function()
      local on_attach = require("plugins.configs.lspconfig").on_attach
      return {
        on_attach = on_attach,
        settings = {
          expose_as_code_action = "all",
        },
      }
    end,
  },

  {
    ft = ft,
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts.servers, {
        b.formatting.prettierd.with {
          filetypes = { "javascript", "typescript", "json", "jsonc" },
        },
      })
    end,
  },

  {
    "nvim-neotest/neotest",
    ft = ft,
    dependencies = {
      "nvim-neotest/neotest-jest",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-jest" {
          jestCommand = "yarn jest --coverage=true --ci",
          env = { NODE_OPTIONS = "--experimental-vm-modules" },
        },
      })
    end,
  },

  {
    "danymat/neogen",
    ft = ft,
    opts = {
      languages = {
        javscript = {
          template = {
            annotation_convention = "jsdoc",
          },
        },

        typescript = {
          template = {
            annotation_convention = "tsdoc",
          },
        },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    opts = {
      setup = {
        vscode_js_debug = function()
          local function get_js_debug()
            local install_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path()
            vim.pretty_print("holis ", install_path)
            return install_path .. "/js-debug/src/dapDebugServer.js"
          end

          require("dap").adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "node",
              args = {
                get_js_debug(),
                "${port}",
              },
            },
          }

          for _, language in ipairs { "typescript", "javascript" } do
            require("dap").configurations[language] = {
              {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
              },
              {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
              },
              {
                type = "pwa-node",
                request = "launch",
                name = "Debug Jest Tests",
                -- trace = true, -- include debugger info
                runtimeExecutable = "node",
                runtimeArgs = {
                  "./node_modules/jest/bin/jest.js",
                  "--runInBand",
                },
                rootPath = "${workspaceFolder}",
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                internalConsoleOptions = "neverOpen",
              },
            }
          end
        end,
      },
    },
  },
}

return plugins
