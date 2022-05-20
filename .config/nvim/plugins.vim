call plug#begin('~/.vim/plugged')

Plug 'projekt0n/github-nvim-theme'
Plug 'glepnir/dashboard-nvim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'elixir-editors/vim-elixir'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'tpope/vim-fugitive'
Plug 'akinsho/bufferline.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'NLKNguyen/papercolor-theme'
Plug 'dense-analysis/ale'

call plug#end()

