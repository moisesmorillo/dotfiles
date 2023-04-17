require("packer").startup(function(use)
  -- Core
  use "wbthomason/packer.nvim"
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate"
  }

  -- Programing lang specific
  use {
    "fatih/vim-go",
    run = ":GoInstallBinaries"
  }

  -- Devtools
  use 'wakatime/vim-wakatime'
  -- Personalization
  use { "catppuccin/nvim", as = "catppuccin" }
  use {
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
    tag = "nightly"
  }
  use {
    "nvim-telescope/telescope.nvim", tag = "0.1.0",
    requires = { { "nvim-lua/plenary.nvim" } }
  }
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true }
  }
  use {
    "akinsho/bufferline.nvim",
    tag = "v3.*",
    requires = "kyazdani42/nvim-web-devicons",
  }
  use "j-hui/fidget.nvim"
  -- Git
  use "tpope/vim-fugitive"
  use "lewis6991/gitsigns.nvim"
  -- Tools
  use "b3nj5m1n/kommentary"
  use "windwp/nvim-autopairs"
  -- LSP
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      {
        'williamboman/mason.nvim',
        run = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }
end)
