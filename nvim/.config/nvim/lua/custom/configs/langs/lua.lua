local ft = "lua"

---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "lua-language-server", "stylua" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = ft,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "lua", "luadoc", "luap", "vim", "vimdoc" })
    end,
  },

  {
    ft = ft,
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          filetypes = { "lua" },

          settings = {
            Lua = {
              codeLens = {
                enable = true,
              },
              completion = {
                autoRequire = true,
                enable = true,
                callSnippet = "Both",
                displayContext = true,
                showParams = true,
              },
              diagnostics = {
                enable = true,
                globals = { "vim" },
                workspaceDelay = 100,
              },
              hint = {
                enable = true,
                paramName = "all",
              },
              workspace = {
                library = {
                  vim.fn.stdpath "data" .. "/lazy/extensions/nvchad_types",
                  vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
                  vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                },
                checkThirdParty = false,
                maxPreload = 100000,
                preloadFileSize = 10000,
              },
            },
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
      vim.list_extend(opts.servers, { b.formatting.stylua })
    end,
  },

  {
    ft = ft,
    "mfussenegger/nvim-dap",
    dependencies = {
      "jbyuki/one-small-step-for-vimkind",
    },
    opts = {
      servers = {
        osv = function()
          local dap = require "dap"
          dap.configurations.lua = {
            {
              type = "nlua",
              request = "attach",
              name = "Attach to running Neovim instance",
              host = function()
                local value = vim.fn.input "Host [127.0.0.1]: "
                if value ~= "" then
                  return value
                end
                return "127.0.0.1"
              end,
              port = function()
                local val = tonumber(vim.fn.input("Port: ", "8086"))
                assert(val, "Please provide a port number")
                return val
              end,
            },
          }

          dap.adapters.nlua = function(callback, config)
            callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
          end
        end,
      },
    },
  },

  {
    "nvim-neotest/neotest",
    ft = ft,
    dependencies = {
      "nvim-neotest/neotest-plenary",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-plenary",
      })
    end,
  },

  {
    "danymat/neogen",
    ft = ft,
    opts = {
      languages = {
        lua = {
          template = {
            annotation_convention = "ldoc",
          },
        },
      },
    },
  },
}

return plugins
