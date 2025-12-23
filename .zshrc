# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
#
#--------------------------
# hammerspoon config
#--------------------------
if [[ "$(uname)" == "Darwin" ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

#--------------------------
# 1password cli config
#--------------------------
if [[ -f ~/.config/op/plugins.sh ]]; then
  source ~/.config/op/plugins.sh
fi

#--------------------------
# nodenv config
#--------------------------

if [[ "$(uname)" == "Linux" ]]; then
  export PATH="$HOME/.nodenv/bin:$PATH"
fi
eval "$(nodenv init - --no-rehash)"

#--------------------------
# go config
#--------------------------
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

#--------------------------
# pyenv config
#--------------------------
if [[ "$(uname)" == "Linux" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  if [[ -d $PYENV_ROOT/bin ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
  fi
fi
eval "$(pyenv init --path)"


#--------------------------
# androidsdk config
#--------------------------
if [[ "$(uname)" == "Darwin" ]]; then
  export ANDROID_SDK_ROOT=$(brew --prefix)/share/android-commandlinetools
fi


#--------------------------
# jenv config
#--------------------------
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

#--------------------------
# cargo config
#--------------------------
source $HOME/.cargo/env


#--------------------------
# enable zoxide
#--------------------------
eval "$(zoxide init zsh)"

#--------------------------
# zsh Configuration
#--------------------------

#---------------------
# Import settings
#---------------------

if [ -e $HOME/.zsh_profile ]; then
    source $HOME/.zsh_profile
fi

path=(
  $HOME/bin(N-/)
  $HOME/.yarn/bin(N-/)
  $HOME/.config/yarn/global/node_modules/.bin(N-/)
  $HOME/.cargo/bin(N-/)
  $path
)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#-----------------------
# Misc Settings
#-----------------------
# History
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# Disable Auto Title (for tmux)
DISABLE_AUTO_TITLE=false

#----------------------
# Bind Key
#----------------------

#----------------
# Completion
#----------------
autoload -U compinit
compinit

# Option
setopt auto_param_slash
setopt mark_dirs
setopt list_types
setopt auto_menu
setopt auto_param_keys
setopt interactive_comments
setopt magic_equal_subst
setopt print_eight_bit
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_ignore_dups
setopt hist_find_no_dups

setopt complete_in_word
setopt always_last_prompt

setopt nonomatch

cdpath=(
  $HOME(N-/)
  $HOME/Documents(N-/)
  $cdpath
)

zstyle ':completion:*:cd:*' tag-order local-directories path-directories

zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} m:=_ m:=- m:=.' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:options' description 'yes'

if [[ "$(uname)" == "Darwin" ]]; then
  eval $(gdircolors)
else
  eval $(dircolors)
fi

zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*' group-name ''
zstyle ':completion:*' use-cache false

export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"

#--------------------------
# antigen config
#--------------------------
if [[ "$(uname)" == "Darwin" ]]; then
  source /opt/homebrew/share/antigen/antigen.zsh
else 
  source ~/.antigen/antigen.zsh
fi

# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
antigen bundle zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999,bg=transparent,bold,underline'

# https://github.com/choplin/cclog
antigen bundle choplin/cclog@main

antigen apply

#--------------------------
# sheldon config
#--------------------------
eval "$(sheldon source)"

# zeno.zsh config is now managed in ~/.config/sheldon/plugins.toml

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
    source "${HOME}/.iterm2_shell_integration.zsh"
fi

# tmux auto start
if [ -z "$TMUX" ]; then
  exec tmux new-session -A
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/shintaro/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/shintaro/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/shintaro/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/shintaro/google-cloud-sdk/completion.zsh.inc'; fi


# Pythonの仮想環境の操作を簡単にする
function venv() {
  case $1 in
    init)
      local CMD='python3 -m venv .venv'
      echo $CMD
      eval $CMD
      ;;
    activate)
      if [ ! -d "./.venv" ]; then
        echo '.venv not found. run `venv init`.'
        return 1
      fi
      local CMD='source .venv/bin/activate'
      echo $CMD
      eval $CMD
      ;;
    *)
      venv activate
      ;;
  esac
}

# Nest.jsへのtailwindcssの導入の自動化
function next-tailwind() {
  if [ $# != 1 ]; then
    echo "invalid auguments"
    return 1
  fi

  case $1 in
    init)
      if [ ! -e "./next.config.js" ]; then
        echo 'this directory is not next.js project'
        return 1
      fi

      local CMD

      CMD="yarn add -D tailwindcss postcss autoprefixer"
      echo $CMD
      eval $CMD

      CMD="yarn tailwindcss init -p"
      echo $CMD
      eval $CMD

      echo "update tailwind.config.js"
      cp ~/.templates/tailwind.config.js ./tailwind.config.js

      echo "update styles/globals.css"
      cp ~/.templates/globals.css ./styles/globals.css

      ;;
    *)
      echo "not found command: $1"
      ;;
  esac
}

# prisma-nestjs-graphqlでの生成したファイルをプロジェクトのフォルダに移行する
function copy-prisma-model() {
  # model.tsの移動
  echo "make folder"
  ls src/@generated/prisma-nestjs-graphql/*/*.model.ts | sed 's/src\/\@generated\/prisma-nestjs-graphql\///g' | sed 's/\/.*//g' | xargs -I {} sh -c 'mkdir src/{}'
  echo "copy model.ts"
  ls src/@generated/prisma-nestjs-graphql/*/*.model.ts | sed 's/src\/\@generated\/prisma-nestjs-graphql\///g' | xargs -I {} sh -c 'cp src/@generated/prisma-nestjs-graphql/{} src/{}'
}

source ~/powerlevel10k/powerlevel10k.zsh-theme

# git 切り替え

source ~/.git_credentials

function delete-url-section-from-gitconfig() {
  git config --list | grep '^url\.' | awk -F'=' '{print $1}' | while read -r urlKey ; do git config --global --unset "$urlKey"; done
}

function git-x1() {
  delete-url-section-from-gitconfig
  git config --global user.name shintaro-x1
  git config --global user.email suzuki.s@x-point-1.net
  git config --global url.https://shintaro-x1:${GITHUB_TOKEN_X1}@github.com/.insteadOf https://github.com/
  git config --global ghq.user shintaro-x1
}

function git-private() {
  delete-url-section-from-gitconfig
  git config --global user.name ShintaroaSuzuki
  git config --global user.email shinbo.dorapion19971221@gmail.com
  git config --global url.https://shintaroasuzuki:${GITHUB_TOKEN_PRIVATE}@github.com/.insteadOf https://github.com/
  git config --global ghq.user ShintaroaSuzuki
}





# tmux を ide のように使う
function ide() {
  if [ "$#" -eq 0 ]; then
    DIR="."
  else
    DIR=$1
  fi

  cd $DIR
  tmux split-window -v
  tmux resize-pane -D 10
  tmux select-pane -t 0
  tmux send-keys 'nvim' C-m 
  sleep 0.2
  tmux select-pane -t 1
  tmux send-keys 'claude' C-m
}

# ポモドーロ用のペーンも用意
function ide_pomo() {
  if [ "$#" -eq 0 ]; then
    DIR="."
  else
    DIR=$1
  fi

  cd $DIR
  tmux split-window -v
  tmux resize-pane -D 10
  tmux split-window -v
  tmux resize-pane -D 5
  tmux select-pane -t 0
  nvim
}

# tmux popup
function tmuxpopup {

  # 変数の設定方法をzshの形式に変更
  local width='80%'
  local height='80%'

  # tmuxセッション名の取得
  local session=$(tmux display-message -p -F "#{session_name}")

  # if文の条件式をzshの形式に変更
  if [[ $session == *popup* ]]; then
    tmux detach-client
  else
    tmux popup -d '#{pane_current_path}' -xC -yC -w$width -h$height -E "tmux attach -t popup || tmux new -s popup"
  fi
}

#--------------------------
# direnv settings
#--------------------------
export EDITOR='nvim'
eval "$(direnv hook zsh)"

#--------------------------
# alias settings
#--------------------------
if [[ -f trash-put ]]; then
  alias rm="trash-put"
fi
alias ls="ls -a"
alias git-tree="git ls-tree -r --name-only HEAD | tree --fromfile"
alias s="tmux copy-mode" # "S"croll
git config --global alias.delete '!git branch | grep -v "master\|main\|*" | xargs -r git branch -D'
git config --global alias.tree 'log --graph --all --format="%x09%C(cyan bold)%an%Creset%x09%C(yellow)%h%Creset %C(magenta reverse)%d%Creset %s"'
ln -s "$(brew --prefix)/bin/claude-squad" "$(brew --prefix)/bin/cs"

# pomodoro
alias work="echo 'we are working! 🎅' | lolcat \
    && timer 25m \
    && osascript -e \
    'display notification \"Work Timer is up! Take a Break ☺️\" with title \"Pomodoro\" sound name \"Crystal\"'"
alias rest="echo 'we are taking a break... 🫖' | lolcat \
    && timer 5m \
    && osascript -e \
    'display notification \"Break Timer is up! Get back to work 🤓\" with title \"Pomodoro\" sound name \"Crystal\"'"

# bun completions
[ -s "/Users/shintaro/.bun/_bun" ] && source "/Users/shintaro/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# GitHub CLI
alias gh="env -u GITHUB_TOKEN gh"

# pnpm
export PNPM_HOME="/Users/shintaro/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# git message template
git config --global commit.template ~/.gitmessage

# settings api key for nvim
set -a
source ~/.config/nvim/.env
set +a

# uv shell completion
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# claude code native install
export PATH="$HOME/.local/bin:$PATH"

#--------------------------
# nb
#--------------------------
# nb add article - Add a note with article title and URL
# Usage: nba <url>              - Auto-fetch title from URL
#        nba <title> <url>      - Use specified title
function nba() {
  if [ $# -lt 1 ]; then
    echo "Usage: nba <url>           # Auto-fetch title"
    echo "       nba <title> <url>   # Manual title"
    return 1
  fi

  local title=""
  local url=""

  if [ $# -eq 1 ]; then
    url="$1"
    echo "Fetching title from: $url"

    title=$(curl -sL --max-redirs 3 --max-time 5 --compressed "$url" | head -c 512 | perl -0777 -ne 'print $1 if /<title[^>]*>([^<]+)<\/title>/i')
    title=$(echo "$title" | perl -pe 's/^\s+|\s+$//g; s/\s+/ /g')

    if [ -z "$title" ]; then
      echo "Error: Could not fetch title from URL"
      return 1
    fi
    echo "Title: $title"
  else
    title="$1"
    url="$2"
  fi

  local content="# ${title}

参照: [${title}](${url})"

  nb add --filename "${title}.md" --content "$content"
  echo "Note created: [${title}](${url})"
}
# nb query - Search notes and select with fzf preview
# Usage: nbq <search query>
function nbq() {
  if [ -z "$1" ]; then
    echo "Usage: nbq <search query>"
    return 1
  fi

  local query="$*"
  local results=$(nb q "$query" --no-color 2>/dev/null | grep -E '^\[[0-9]+\]')

  if [ -z "$results" ]; then
    echo "No results found for: $query"
    return 1
  fi

  export _NBQ_QUERY="$query"

  local selected=$(echo "$results" | fzf --ansi \
    --preview 'note_id=$(echo {} | sed -E "s/^\[([0-9]+)\].*/\1/")
               echo "=== Note [$note_id] ==="
               echo ""
               nb show "$note_id" | head -5
               echo ""
               echo "=== Matching lines ==="
               echo ""
               nb show "$note_id" | grep -i --color=always -C 2 "$_NBQ_QUERY" | head -30' \
    --preview-window=right:60%:wrap \
    --header "Search: $query")

  unset _NBQ_QUERY

  if [ -n "$selected" ]; then
    local note_id=$(echo "$selected" | sed -E 's/^\[([0-9]+)\].*/\1/')
    nb edit "$note_id"
  fi
}

# nb web - Fetch webpage, convert to markdown, and save as note
# Usage: nbw <notebook> <url>              - Auto-fetch title
#        nbw <notebook> <title> <url>      - Manual title
function nbw() {
  if [ $# -lt 2 ]; then
    echo "Usage: nbw <notebook> <url>           # Auto-fetch title"
    echo "       nbw <notebook> <title> <url>   # Manual title"
    return 1
  fi

  if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed"
    return 1
  fi

  local notebook="$1"
  local title=""
  local url=""

  if [ $# -eq 2 ]; then
    url="$2"
  else
    title="$2"
    url="$3"
  fi

  echo "Fetching: $url"

  local html=$(curl -sL --max-redirs 5 --max-time 30 --compressed "$url")

  if [ -z "$html" ]; then
    echo "Error: Could not fetch content from URL"
    return 1
  fi

  if [ -z "$title" ]; then
    title=$(echo "$html" | head -c 2048 | perl -0777 -ne 'print $1 if /<title[^>]*>([^<]+)<\/title>/i')
    title=$(echo "$title" | perl -pe 's/^\s+|\s+$//g; s/\s+/ /g')

    if [ -z "$title" ]; then
      title=$(echo "$url" | sed -E 's|https?://([^/]+).*|\1|')
    fi
    echo "Title: $title"
  fi

  local markdown=$(echo "$html" | pandoc -f html -t markdown_strict-raw_html 2>/dev/null)

  if [ -z "$markdown" ]; then
    echo "Error: pandoc conversion failed"
    return 1
  fi

  local content="# ${title}

> 元記事: [${title}](${url})

---

${markdown}"

  nb "${notebook}:" add --content "$content"
  echo "Note created in ${notebook}: ${title}"
}
