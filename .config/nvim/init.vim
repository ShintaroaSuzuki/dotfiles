" python3 setting
let g:python3_host_prog = '/Users/shintaro/.pyenv/shims/python3'

" node setting
let g:node_host_prog = '/Users/shintaro/.nodenv/versions/16.16.0/lib/node_modules/neovim/bin/cli.js'

" copilot setting
let g:copilot_node_command = '/Users/shintaro/.nodenv/versions/16.16.0/bin/node'

" Enable flake8 and mypy
let g:lsp_settings = {
\  'pylsp-all': {
\    'workspace_config': {
\      'pylsp': {
\        'configurationSources': ['flake8'],
\        'plugins': {
\          'flake8': {
\            'enabled': 1,
\          },
\          'mccabe': {
\            'enabled': 0,
\          },
\          'pycodestyle': {
\            'enabled': 0,
\          },
\          'pyflakes': {
\            'enabled': 0,
\          },
\          'pylsp_mypy': {
\            'enabled': 1,
\          },
\        }
\      }
\    }
\  }
\}

" enable golangci-lint-langserver
let g:lsp_settings_filetype_go = ['gopls', 'golangci-lint-langserver']

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

" indentLine
let g:indentLine_enebled = 0
let g:indentLine_char = '¦'
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = '.'
let g:indentLine_fileTypeExclude = ['nerdtree']

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

" show hidden files in NERDTree
let NERDTreeShowHidden = 1

set exrc

augroup fmt
autocmd!
" vim-prettier
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.svelte,*.yml,*.yaml,*.html,*.astro PrettierAsync
" vim-gofmt
autocmd BufWritePre *go GoFmt
" gci
autocmd BufWritePre *go execute ':silent !gci write %'
augroup END

" nvim-lualine
lua << END
  require('lualine').setup()
END

" nvim-autopairs
lua << EOF
  require('nvim-autopairs').setup {}
EOF

" vim-black
augroup black_on_save
  autocmd!
  autocmd BufWritePre *.py Black
augroup end

" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" vim-translator
let g:translator_target_lang = 'ja'
let g:translator_source_lang = 'auto'
let g:translator_default_engines = ['google']

" vim-brightest
let g:brightest#highlight = { "group": "BrightestUnderline" }
let g:brightest#pattern = '\k\+'

" vim-quickhl
nmap <Space>h <Plug>(quickhl-manual-this)
xmap <Space>h <Plug>(quickhl-manual-this)
nmap <Space>H <Plug>(quickhl-manual-reset)

" vim-signature
let g:SignatureMap = { 'Leader' : "m", 'PlaceNextMark' : "", 'ToggleMarkAtLine' : "<Space>m", 'PurgeMarksAtLine' : "", 'DeleteMark' : "", 'PurgeMarks' : "", 'PurgeMarkers' : "", 'GotoNextLineAlpha' : "", 'GotoPrevLineAlpha' : "", 'GotoNextSpotAlpha' : "", 'GotoPrevSpotAlpha' : "", 'GotoNextLineByPos' : "", 'GotoPrevLineByPos' : "", 'GotoNextSpotByPos' : "", 'GotoPrevSpotByPos' : "", 'GotoNextMarker' : "", 'GotoPrevMarker' : "", 'GotoNextMarkerAny' : "", 'GotoPrevMarkerAny' : "", 'ListBufferMarks' : "", 'ListBufferMarkers' : "" }
let g:SignatureIncludeMarks = "abcdefghijklmnopqrstuvwxyz"

" ファイル、ディレクトリのコピー
command! CopyRelativePath :call s:CopyRelativePath()
function! s:CopyRelativePath()
  let @* = expand('%')
endfunction

command! CopyAbsolutePath :call s:CopyAbsolutePath()
function! s:CopyAbsolutePath()
  let @* = expand('%:p')
endfunction

command! CopyDir :call s:CopyDir()
function! s:CopyDir()
  let @* = expand('%:p:h')
endfunction

" memo
command! Memo :call s:Memo()
function! s:Memo()
    vsplit
    wincmd w
    edit ~/.memo.md
endfunction
