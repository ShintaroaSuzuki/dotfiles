if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'tpope/vim-fugitive' " git 操作✔
Plug 'tpope/vim-rhubarb' " github 操作✔
Plug 'tpope/vim-commentary' " 選択範囲ををコメントアウト
Plug 'arcticicestudio/nord-vim' " カラースキーム
Plug 'mattn/emmet-vim' " html/css/js の補完
Plug 'mattn/vim-maketable' " markdown でテーブルを作成
Plug 'tpope/vim-surround' " タグを囲む✔
Plug 'junegunn/vim-easy-align' " 選択範囲を揃える✔
Plug 'psf/black', { 'branch': 'stable' } " python のフォーマッタ✔
Plug 'yggdroot/indentline' " インデントを表示✔
Plug 'junegunn/fzf', { 'do': { -> fzf"install() } } # fzf
Plug 'junegunn/fzf.vim' " fzf
Plug 'voldikss/vim-translator' " 翻訳
Plug 'kamykn/spelunker.vim' " スペルチェック
Plug 't9md/vim-quickhl' " 検索結果をハイライト✔
Plug 'osyo-manga/vim-brightest' " カーソル下の単語をハイライト
Plug 'kshenoy/vim-signature' " マーカーの表示✔
Plug 'wuelnerdotexe/vim-astro' " astro のシンタックスハイライト
Plug 'darrikonn/vim-gofmt', { 'do': ':GoUpdateBinaries' } " go のフォーマッタ✔

if has("nvim")
  Plug 'preservim/nerdtree' " ファイルツリー✔
  Plug 'ryanoasis/vim-devicons' " ファイルアイコン✔
  Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' } " prettier✔
  Plug 'prabirshrestha/vim-lsp' " lsp✔
  Plug 'mattn/vim-lsp-settings' " lsp✔
  Plug 'mattn/vim-lsp-icons' " lsp✔
  Plug 'prabirshrestha/asyncomplete.vim' " lsp✔
  Plug 'prabirshrestha/asyncomplete-lsp.vim' " lsp✔
  Plug 'github/copilot.vim' " copilot✔
  Plug 'nvim-lualine/lualine.nvim' " statusline✔
  Plug 'kyazdani42/nvim-web-devicons' " ファイルアイコン✔
  Plug 'windwp/nvim-autopairs' " 括弧の自動補完✔
endif

call plug#end()
