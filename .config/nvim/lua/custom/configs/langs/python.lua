local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local util = require "lspconfig.util"

local get_poetry_venv_path = function()
  local fn = vim.fn
  if fn.executable "poetry" == 1 then
    return fn.trim(fn.system "poetry config virtualenvs.path")
  end

  return ""
end

---@type NvPluginSpec[]
return {
  {
    "williamboman/mason.nvim",
    ft = "python",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "pyright", "ruff", "ruff-lsp", "black", "debugpy" })

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    ft = "python",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "python" })

      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = "python",
    opts = {
      servers = {
        pyright = {
          on_attach = on_attach,
          capabilities = capabilities,
          filetypes = { "python" },
          root_dir = util.root_pattern("requirements.txt", "pyproject.toml", "poetry.lock", ".git"),

          settings = {
            pyright = {
              venvPath = get_poetry_venv_path(),
            },
            analysis = {
              typeCheckingMode = "off",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
        ruff_lsp = {
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end,
          capabilities = capabilities,
          filetypes = { "python" },
          root_dir = util.root_pattern("requirements.txt", "pyproject.toml", "poetry.lock", ".git"),
        },
      },
    },
  },

  {
    ft = "python",
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local b = require("null-ls").builtins
      vim.list_extend(opts.servers, { b.formatting.black.with { extra_args = { "-l", "79", "-double-quote" } } })

      return opts
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "mfussenegger/nvim-dap-python" },
    opts = {
      servers = {
        debugpy = function()
          require("custom.configs.dap").set_python_debugger()
          table.insert(require("dap").configurations.python, {
            type = "python",
            request = "attach",
            connect = {
              port = 5678,
              host = "127.0.0.1",
            },
            mode = "remote",
            name = "container attach debug",
            cwd = vim.fn.getcwd(),
            pathmappings = {
              {
                localroot = function()
                  return vim.fn.input("local code folder > ", vim.fn.getcwd(), "file")
                end,
                remoteroot = function()
                  return vim.fn.input("container code folder > ", "/", "file")
                end,
              },
            },
          })
          require("core.utils").load_mappings "python"
        end,
      },
    },
  },
}
