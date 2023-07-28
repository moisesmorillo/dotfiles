---@diagnostic disable: missing-fields
---@type NvPluginSpec[]
return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- Overwrite defaults ensure_installed from nvchad
      local ensure_installed = {
        -- bash stuff
        -- "bash-language-server",
        -- sql stuff
        -- "sqlls",
        -- yaml stuff
        -- "yaml-language-server",
        -- others
        "write-good",
        -- shell
        "shfmt",
      }
      vim.list_extend(opts.ensure_installed, ensure_installed)

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    -- Overwrite nvchad defaults
    opts = {
      ensure_installed = {
        "bash",
        "dockerfile",
        "jsdoc",
        "json",
        "jsonc",
        "json5",
        "make",
        "markdown",
        "markdown_inline",
        "mermaid",
        "regex",
        "sql",
        "terraform",
        "toml",
        "yaml",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },

  -- highlight for lsp servers not compatible with semantic tokens
  {
    "m-demare/hlargs.nvim",
    event = "VeryLazy",
    opts = {
      color = "#fab387",
      use_colorpalette = false,
      disable = function(_, bufnr)
        if vim.b.semantic_tokens then
          return true
        end
        local clients = vim.lsp.get_active_clients { bufnr = bufnr }
        for _, c in pairs(clients) do
          local caps = c.server_capabilities
          if c.name ~= "null-ls" and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            vim.b.semantic_tokens = true
            return vim.b.semantic_tokens
          end
        end
      end,
    },
  },

  {
    "andymass/vim-matchup",
    event = "VeryLazy",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      -- TODO fix this
      -- {
      --   "folke/neoconf.nvim",
      --   cmd = "Neoconf",
      --   opts = {},
      -- },
      {
        "folke/neodev.nvim",
        opts = {
          debug = true,
        },
      },
      { "smjonas/inc-rename.nvim", opts = {} },
    },
    opts = {
      servers = {},
    },
    config = function(_, opts)
      local lspconfig = require "lspconfig"

      for server, setup in pairs(opts.servers) do
        lspconfig[server].setup(setup)
      end
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    opts = function()
      local b = require("null-ls").builtins

      return {
        servers = {
          b.diagnostics.write_good.with {
            filetypes = { "python", "go", "markdown", "typescript", "javascript", "rust" },
          },
          b.formatting.shfmt,
        },
      }
    end,
    config = function(_, opts)
      require("custom.configs.null-ls").setup(opts.servers)
    end,
  },

  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
    opts = {
      servers = {},
    },
    config = function(plugin, opts)
      require("telescope").load_extension "dap"
      require("nvim-dap-virtual-text").setup {
        commented = true,
      }
      local dap = require "custom.configs.dap"
      dap.setup()

      require("core.utils").load_mappings "dap"

      -- set up debuggers
      for k, _ in pairs(opts.servers) do
        opts.servers[k](plugin, opts)
      end
    end,
  },
}
