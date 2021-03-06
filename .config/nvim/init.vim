" python3 setting
let g:python3_host_prog = '/Users/shintaro/.pyenv/shims/python3'

" init autocmd
autocmd!
" set script encoding
scriptencoding utf-8
" stop loading config if it's on tiny or small
if !1 | finish | endif

set number
set hlsearch
set ignorecase
set incsearch
set smartcase
set laststatus=2
set autoindent
set showcmd
set shell=/bin/zsh
set expandtab
 
" access to clipboard
set clipboard=unnamedplus

" indents
filetype plugin indent on
set shiftwidth=2
set tabstop=2
set ai "Auto indent
set si "Smart indent
set nowrap "No Wrap lines
set backspace=start,eol,indent

" Finding files - Search down into subfolders
set path+=**
set wildignore+=*/node_modules/*

" incremental substitution (neovim)
if has("nvim")
  set inccommand=split
endif

" imports
runtime ./plug.vim
if has("unix")
  let s:uname = system("uname -s")
endif

runtime ./maps.vim

" color theme
if exists("&termguicolors") && exists("&winblend")
  syntax enable
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
  set background=dark
  colorscheme nord
  let s:bg_back = ' guibg=NONE ctermbg=NONE'
  let s:fmt_none = ' gui=NONE cterm=NONE,underline'
  let s:fg_base0 = ' guifg=NONE ctermfg=NONE'
  exe "hi! Normal" .s:fmt_none .s:fg_base0 .s:bg_back
  exe "hi! NonText guibg=NONE guibg=NONE"
  exe "hi! LineNr guibg=NONE guibg=NONE"
  exe "hi! Folded guibg=NONE guibg=NONE"
  exe "hi! EndOfBuffer guibg=NONE guibg=NONE"
endif
    
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

set exrc

" vim-prettier
augroup fmt
autocmd!
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.svelte,*.yaml,*.html PrettierAsync
augroup END

" nvim-lualine
lua << END
  require('lualine').setup()
END

" nvim-autopairs
lua << EOF
  require('nvim-autopairs').setup {}
EOF
