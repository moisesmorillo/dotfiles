call plug#begin('~/.vim/plugged')

Plug 'glepnir/dashboard-nvim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'NLKNguyen/papercolor-theme'
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'

call plug#end()

" Set global colorscheme
colorscheme PaperColor

