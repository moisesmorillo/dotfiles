require("packer").startup(function(use)
  -- Core  
  use "wbthomason/packer.nvim"
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate"
  }

  -- Programing lang specific
  use "fatih/vim-go"

  -- Devtools
  use 'wakatime/vim-wakatime'
  
  -- Personalization
  use "EdenEast/nightfox.nvim"
  use {
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
    tag = "nightly" 
  }
  use {
    "nvim-telescope/telescope.nvim", tag = "0.1.0",
    requires = { {"nvim-lua/plenary.nvim"} }
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
end)
