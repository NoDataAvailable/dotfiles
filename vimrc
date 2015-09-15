
let $PYTHONPATH="/usr/lib/python3.3/site-packages"
set shell=zsh

filetype off                  " required!
set nocompatible
set laststatus=2
set encoding=utf-8

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()


" Vundle
Bundle 'gmarik/vundle'

" Passive
Bundle 'ervandew/supertab'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/syntastic'
Bundle 'airblade/vim-gitgutter'
Bundle 'kien/rainbow_parentheses.vim'

" Active
Bundle 'sjl/gundo.vim'
Bundle 'majutsushi/tagbar'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'edkolev/tmuxline.vim'
Bundle 'edkolev/promptline.vim'
Bundle 'kien/ctrlp.vim'
Bundle "godlygeek/tabular"

" Colours
Bundle 'tomasr/molokai'
Bundle 'junegunn/seoul256.vim'
Bundle 'trapd00r/neverland-vim-theme'
Bundle 'altercation/vim-colors-solarized'

" Language Support
Bundle 'marijnh/tern_for_vim'
Bundle 'Rip-Rip/clang_complete'
Bundle 'kchmck/vim-coffee-script'


" Generic Vim settings
filetype plugin indent on
syntax on
set incsearch
set mouse=a
set foldmethod=syntax
set foldnestmax=4
set number                  " show line number
set relativenumber          " (try to) show relative line numbers
set cursorline
set smarttab
set autoindent
set smartindent
set hidden
set ttyfast
set et ts=4 sts=4 sw=4      " No tabs, 4 spaces instead
set textwidth=80            " 80 character/line limit
set formatoptions+=t
set colorcolumn=+1          " Put the 80 char warning track on col 81
set t_Co=256
" gVim only
set guifont=GohuFont\ 7
set guioptions-=m           " remove menu bar
set guioptions-=T           " remove toolbar
set guioptions-=r           " remove right-hand scroll bar
set guioptions-=L           " remove left-hand scroll bar

" Folding for languages
let javaScript_fold=1

" Plugin configs
" Colors for themes?
let g:solarized_termcolors=256
let g:rehash256 = 1
" Syntastic
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_html_checkers = ['jshint', 'validator']
" CtrlP
let g:ctrlp_max_files = 0
" Airline + derivatives
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme='molokai'
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'b'    : '#W',
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W'],
      \'x'    : [' ', '♫ #(mpc)'],
      \'y'    : ['%a', '%R'],
      \'z'    : '#H',
      \ 'options': {
          \'status-justify': 'left' }
      \}
" Rainbow parentheses
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['87',       'firebrick3'],
    \ ['82',        'RoyalBlue3'],
    \ ['220',       'SeaGreen3'],
    \ ['201', 'DarkOrchid3'],
    \ ['231',    'firebrick3'],
    \ ['118',   'RoyalBlue3'],
    \ ['195',    'SeaGreen3'],
    \ ['196',     'DarkOrchid3'],
    \ ['254',         '#ddd'],
    \ ]
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces


" Colors (Duh)
colors molokai
" EOL highlighting
hi CursorLine  cterm=NONE ctermbg=black guibg=black
hi SignColumn  cterm=NONE ctermbg=black guibg=black
hi ColorColumn cterm=NONE ctermbg=black guibg=black


" Key mappings
nnoremap <F12> :lnext<CR>
nnoremap <F11> :lprev<CR>
nnoremap <F8>  :TagbarToggle<CR>
nnoremap <F6>  :NERDTree<CR>
nnoremap <F5>  :GundoToggle<CR>
" Remove Whitespace
nnoremap <silent> <F4> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" Window nav
nmap <silent> <A-Up>    :wincmd k<CR>
nmap <silent> <A-Down>  :wincmd j<CR>
nmap <silent> <A-Left>  :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>


" Auto-complete nonsense
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap " <c-r>=QuoteDelim('"')<CR>
inoremap ' <c-r>=QuoteDelim("'")<CR>

function ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    return a:char
  endif
endf

function CloseBracket()
  if match(getline(line('.') + 1), '\s*}') < 0
    return "\<CR>}"
  else
    return "\<Esc>j0f}a"
  endif
endf

function QuoteDelim(char)
  let line = getline('.')
  let col = col('.')
  if line[col - 2] == "\\"
    "Inserting a quoted quotation mark into the string
    return a:char
  elseif line[col - 1] == a:char
    "Escaping out of the string
     return "\<Right>"
  else
    "Starting a string
    return a:char.a:char."\<Esc>i"
  endif
endf

let g:powerline_loaded = 1
