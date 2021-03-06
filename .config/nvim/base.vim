" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Set terminal messages size
set cmdheight=2

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" Set shift width to 2 spaces.
set shiftwidth=2

" Set tab width to 2 columns.
set tabstop=2

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
set nobackup

" Do not save swaf files.
set noswapfile

" The number of screen lines to keep above and below the cursor
set scrolloff=2

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history for undo default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=longest:full,list:full

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Set default encoding utf-8
set encoding=utf-8

" Set file format to unix (LF)
set fileformat=unix

" Automatically indent new lines
set autoindent

" Always display status bar
set laststatus=2

" Enable OS clipboard
set clipboard=unnamed

" Always show cursor position
set ruler

" Set key leader to space
let mapleader=" "

" Disable beep on errors
set noerrorbells

" Enables 24-bit RGB color in the TUI
set termguicolors

" Enable colorized maxlength line size
set colorcolumn=80

" Enable spell check
set spell spelllang=en_us

" Set background to dark
set background=dark

" Set encoding UTF-8
set encoding=UTF-8
