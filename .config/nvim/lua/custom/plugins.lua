---@diagnostic disable: missing-fields
local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  {
    import = "custom.configs.langs",
  },

  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, overrides.mason.ensure_installed)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, overrides.treesitter.ensure_installed)
      opts.auto_install = true

      return opts
    end,
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
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", opts = {} },
      { "folke/neodev.nvim", opts = {} },
      { "smjonas/inc-rename.nvim", opts = {} },
    },
    config = function(_, opts)
      local lspconfig = require "lspconfig"

      for server, v in pairs(opts) do
        lspconfig[server].setup(v)
      end
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local b = require("null-ls").builtins

      -- default
      vim.list_extend(opts, {
        b.diagnostics.write_good.with {
          filetypes = { "python", "go", "markdown", "typescript", "javascript", "rust" },
        },
      })
      return opts
    end,
    config = function(_, opts)
      require("custom.configs.null-ls").setup(opts)
    end,
  },

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = "VeryLazy",
    version = "*",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      theme = "catppuccin",
    },
  },

  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",

    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, _)
      local dap = require "custom.configs.dap"
      dap.setup()

      require("core.utils").load_mappings "dap"
    end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
    dependencies = {
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = overrides.gitsigns,
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    init = function()
      vim.g.lazygit_use_custom_config_file_path = 1
      vim.g.lazygit_config_file_path = "~/.config/lazygit/config.yml"
      require("core.utils").load_mappings "lazygit"
    end,
  },

  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },

  -- {
  --   "andythigpen/nvim-coverage",
  --   branch = "main",
  --   cmd = { "Coverage", "CoverageShow", "CoverageHide", "CoverageToggle", "CoverageSummary" },
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   opts = {
  --     commands = true,
  --     load_coverage_cb = function(ftype)
  --       vim.notify("Loaded " .. ftype .. " coverage") -- TODO change this by nvim notify
  --     end,
  --     lang = {
  --       python = {
  --         coverage_file = "project/.coverage",
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     require("coverage").setup(opts)
  --   end,
  -- },

  -- {
  --   "rcarriga/nvim-notify",
  --   event = "VeryLazy",
  --   config = function(_, _)
  --     require("notify").setup {}
  --   end,
  -- },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     flavour = "mocha",
  --     integrations = {
  --       notify = true,
  --       fidget = true,
  --     },
  --   },
  --   config = function(_, opts)
  --     require("catppuccin").setup(opts)
  --   end,
  -- },
  --
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   enabled = false,
  --   event = "VeryLazy",
  --   config = function()
  --     require("chatgpt").setup {
  --       api_key_cmd = "op read op://Work/OpenAI_API_Key/api_key_cmd --no-newline",
  --       openai_params = {
  --         model = "gpt-4",
  --       },
  --     }
  --   end,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- },

  -- {
  --   "github/copilot.vim",
  --   enabled = false,
  --   event = "VeryLazy",
  -- },
}

return plugins
