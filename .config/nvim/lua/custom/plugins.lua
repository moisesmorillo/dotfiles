---@diagnostic disable: missing-fields
local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  {
    import = "custom.configs.langs",
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

  -- {
  --   "stevearc/dressing.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  -- },

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
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-dap.nvim",
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
