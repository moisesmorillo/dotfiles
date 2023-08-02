local ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" }

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "typescript-language-server", "prettierd", "deno" })
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
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      servers = {
        tsserver = {
          filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          root_dir = { "package.json", "yarn.lock", "package-lock.json", ".git" },
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
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
    ft = ft,
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts.servers, {
        b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } },
        b.formatting.deno_fmt.with {
          extra_args = { "--single-quote" },
        }, -- choosed deno for ts/js files cuz its very fast!
        require "typescript.extensions.null-ls.code-actions",
      })
    end,
  },

  {
    "nvim-neotest/neotest",
    ft = ft,
    dependencies = {
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-jest" {
          jestCommand = "npx jest --bail --verbose --ci --outputFile=lcov.info --",
          env = { NODE_OPTIONS = "--experimental-vm-modules" },
          jestConfigFile = "jest.config.js",
        },
        require "neotest-vitest",
        require("neotest-playwright").adapter {
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
          },
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
    ft = ft,
    dependencies = {
      { "mxsdev/nvim-dap-vscode-js" },
      {
        "microsoft/vscode-js-debug",
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
      },
    },
    opts = {
      setup = {
        vscode_js_debug = function()
          local function get_js_debug()
            local path = vim.fn.stdpath "data"
            return path .. "/lazy/vscode-js-debug"
          end

          require("dap-vscode-js").setup {
            node_path = "node",
            debugger_path = get_js_debug(),
            adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
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
              {
                type = "pwa-chrome",
                name = "Attach - Remote Debugging",
                request = "attach",
                program = "${file}",
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                webRoot = "${workspaceFolder}",
              },
              {
                type = "pwa-chrome",
                name = "Launch Chrome",
                request = "launch",
                url = "http://localhost:5173", -- This is for Vite. Change it to the framework you use
                webRoot = "${workspaceFolder}",
                userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
              },
            }
          end
        end,
      },
    },
  },

  -- TODO: add https://github.com/pmizio/typescript-tools.nvim
}

return plugins
