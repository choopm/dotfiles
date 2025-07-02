filetype plugin indent on

source ~/.config/nvim/plugin.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on " Enable syntax highlighting
filetype plugin indent on" Enable filetype-specific indenting and plugins

set autoread              " Automatically read file when changed outside Vim
set history=100 	        " Keep 100 lines of command line history
set viminfo^=%            " Remember info about open buffers on close
set ttyfast               " this is the 21st century, people
set nrformats-=octal      " always assume decimal numbers
set nocompatible
set mouse=a

let loaded_matchparen = 1 " this should fix issue with long lines

let mapleader = ","
let g:mapleader = ","

ca W w
ca h tab help

" Set augroup
augroup MyAutoCmd
   autocmd!
augroup END

set statusline=

let g:python3_host_prog = '/usr/bin/python3'
