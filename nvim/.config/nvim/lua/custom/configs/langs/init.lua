---@type NvPluginSpec[]
local plugins = {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- Overwrite defaults ensure_installed from nvchad
      -- FIX: split into file-specifc settings or enable bellow
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
    "folke/neoconf.nvim",
    opts = {},
  },

  {
    "folke/neodev.nvim",
    opts = {
      setup_jsonls = false,
      library = { plugins = { "neotest", "nvim-dap-ui" }, types = true },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      { "smjonas/inc-rename.nvim", opts = {} },
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
        config = function(_, opts)
          require("core.utils").load_mappings "navbuddy"
          require("nvim-navbuddy").setup(opts)
        end,
      },
    },
    opts = {
      servers = {},
    },
    config = function(_, opts)
      require("neoconf").setup()
      require("neodev").setup()
      local lspconfig = require "lspconfig"
      local on_attach = require("plugins.configs.lspconfig").on_attach
      local capabilities = require("plugins.configs.lspconfig").capabilities
      local util = require "lspconfig.util"

      -- this is for nvim-ufo client
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      for server, setup in pairs(opts.servers) do
        if setup.on_attach == nil then
          setup.on_attach = on_attach
        end

        if setup.capabilities == nil then
          setup.capabilities = capabilities
        end

        if setup.root_dir and type(setup.root_dir) == "table" then
          setup.root_dir = util.root_pattern(setup.root_dir)
        end

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

  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-plenary",
      { "stevearc/overseer.nvim", opts = {} },
    },
    opts = {
      adapters = {
        library = { plugins = { "neotest" }, types = true },
      },
    },
    config = function(_, opts)
      vim.list_extend(opts.adapters, {
        require "neotest-plenary",
      })

      opts.consumers = {
        overseer = require "neotest.consumers.overseer",
      }
      opts.overseer = {
        enabled = true,
        force_default = true,
      }

      require("core.utils").load_mappings "neotest"
      require("core.utils").load_mappings "overseer"

      require("neotest").setup(opts)
    end,
  },

  {
    "danymat/neogen",
    event = "VeryLazy",
    opts = {
      enabled = true,
      snippet_engine = "luasnip",
      languages = {},
    },
    config = function(_, opts)
      require("core.utils").load_mappings "neogen"
      require("neogen").setup(opts)
    end,
  },
}

return plugins
