let $PYTHONPATH="/usr/lib/python3.3/site-packages"

filetype off                  " required!
set nocompatible
set laststatus=2
set encoding=utf-8

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'Rip-Rip/clang_complete'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
" Bundle 'bling/vim-bufferline'
Bundle 'bling/vim-airline'
Bundle 'edkolev/tmuxline.vim'
Bundle 'edkolev/promptline.vim'
Bundle 'airblade/vim-gitgutter'
" Bundle 'mhinz/vim-signify'
Bundle 'sjl/gundo.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tomasr/molokai'
Bundle 'ervandew/supertab'
Bundle 'trapd00r/neverland-vim-theme'


filetype plugin indent on
syntax on
set incsearch
set mouse=a
set foldmethod=syntax
set foldnestmax=1
set nu
set relativenumber
set cursorline
set smarttab
set autoindent
set smartindent
set hidden
set ts=4 sts=4 sw=4
set textwidth=80
set formatoptions+=t
set colorcolumn=+1

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:solarized_termcolors=256
let g:rehash256 = 1
let g:airline_theme='simple'
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

colors molokai


" Mappings

nnoremap <F5> :GundoToggle<CR>
" Remove Whitespace
nnoremap <silent> <F4> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
hi CursorLine cterm=NONE ctermbg=black guibg=black
hi SignColumn cterm=NONE ctermbg=black guibg=black
hi ColorColumn cterm=NONE ctermbg=black guibg=black

inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {<CR>}<Esc>O
autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=CloseBracket()<CR>
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
