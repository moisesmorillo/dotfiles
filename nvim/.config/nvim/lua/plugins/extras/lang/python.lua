---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
              },
            },
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "debugpy" },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = { justMyCode = false },
          runner = "pytest",
          is_test_file = function(file_path)
            return string.match(file_path, ".py$") ~= nil and string.match(file_path, "test?") ~= nil
          end,
        },
      },
    },
  },
  {
    "danymat/neogen",
    opts = {
      languages = {
        python = {
          template = {
            annotation_convention = "numpydoc",
          },
        },
      },
    },
  },
  {
    "neolooong/whichpy.nvim",
    keys = {
      { "<leader>cv", "<cmd>:WhichPy select<cr>", desc = "Select VirtualEnv", ft = "python" },
    },
    opts = {
      picker = {
        ["fzf-lua"] = {
          prompt = "Select Python Interpreter",
        },
      },
    },
  },
}
