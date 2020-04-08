set nocompatible              " be iMproved, required
filetype off                  " required

let mapleader=","

" Vundle plugin configuration
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugin Vundle
Plugin 'VundleVim/Vundle.vim'

" Plugin Ctrl+p (MRU, files, buffers)
Plugin 'kien/ctrlp.vim'
" map <Leader>p :CtrlPMixed<CR>
map <Leader>p :CtrlPMRUFiles<CR>
map <Leader>o :CtrlPBuffer<CR>
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" Plugin nerdtree
Plugin 'scrooloose/nerdtree'
map <F5> :NERDTreeToggle<CR>
map <Leader>l :NERDTreeToggle<CR>
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"autocmd VimEnter * if argc() != 0 | NERDTreeFind | wincmd l | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeWinSize=45
let NERDTreeShowHidden=1

" Plugin matchit, allow '%' for XML, if/fi, etc
Plugin 'geoffharcourt/vim-matchit'

" Plugin restore cursor position
Plugin 'farmergreg/vim-lastplace'

" Plugin highlight trailing whitespace
Plugin 'ntpeters/vim-better-whitespace'
let g:strip_whitespace_on_save = 1

" Plugin git commands from vim, :Glog :Gblame, ..
Plugin 'tpope/vim-fugitive'

" Plugin git modified lines
Plugin 'airblade/vim-gitgutter'

" Plugin syntax checking
"Plugin 'scrooloose/syntastic'
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" Plugin statusline & tabbar
Plugin 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
map <F2> :bprevious<CR>
map <F3> :bnext<CR>
map <F4> :bdelete<CR>

" Autocompletion
Plugin 'ycm-core/YouCompleteMe'
let g:ycm_auto_trigger = 1
let g:ycm_confirm_extra_conf = 0

call vundle#end()
" End of Vundle plugin configuration

filetype plugin indent on

" General stuff
set nowrap
set autoindent
set shiftwidth=4
set expandtab
set tabstop=2
set softtabstop=2
set nojoinspaces
set splitright
set splitbelow
set mouse=a
set number
set t_Co=256
syntax enable
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.mp3,/tmp/*

" Global undo files
set undodir=~/.vim/undodir
set undofile

" Move .swp files
set directory^=$HOME/.vim/swp//
" Move Vim history
set viminfofile=$HOME/.vim/viminfo

" Compile and execute
map <F8> : !g++ -std=c++17 -g -O2 -pipe -Wall -Wextra -o /tmp/.a.out % && /tmp/.a.out <CR>

" default colors
colorscheme desert
highlight LineNr ctermfg=8
" vimdiff colors
if &diff
  highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
  highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
  highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
  highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red
endif

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

