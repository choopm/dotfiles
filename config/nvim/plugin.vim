if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
  """"""""""""""""""
  " Visual Plugins "
  """"""""""""""""""
  Plug 'ellisonleao/gruvbox.nvim'
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'ryanoasis/vim-devicons'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'majutsushi/tagbar'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  """"""""""""""""""
  " Helper Plugins "
  """"""""""""""""""
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'rstacruz/vim-closer'
  Plug 'easymotion/vim-easymotion'
  Plug 'jeffkreeftmeijer/vim-numbertoggle'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-git', {'autoload':{'filetypes':['gitcommit','gitconfig', 'gitrebase', 'gitsendmail']}}
  Plug 'kdheepak/lazygit.nvim'
  Plug 'vimwiki/vimwiki'
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'rking/ag.vim'
  Plug 'godlygeek/tabular', {'autoload':{'commands':'Tabularize'}}

  """"""""""""""""""""
  " Language support "
  """"""""""""""""""""
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'rust-lang/rust.vim'
  Plug 'mattn/emmet-vim', {'autoload':{'filetypes':['html','css','sass','scss','less']}}
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'tpope/vim-dispatch'
  Plug 'prettier/vim-prettier'
  Plug 'nvim-treesitter/nvim-treesitter'
  " Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'

call plug#end()

if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
