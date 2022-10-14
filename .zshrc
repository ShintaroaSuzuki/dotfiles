# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#--------------------------
# nodenv config
#--------------------------
export PATH="$HOME/.nodenv/bin:$PATH"
export PATH="/Users/shintaro/.nodenv/versions/16.16.0/bin:$PATH"
eval "$(nodenv init -)"

#--------------------------
# goenv config
#--------------------------
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

#--------------------------
# pyenv config
#--------------------------
eval "$(pyenv init --path)"

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

LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

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

zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*' group-name ''
zstyle ':completion:*' use-cache false

export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"

#--------------------------
# antigen config
#--------------------------
source /opt/homebrew/share/antigen/antigen.zsh

# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
antigen bundle zsh-users/zsh-syntax-highlighting

# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
antigen bundle zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#333333,bg=transparent,bold,underline'

antigen apply

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
function git-x1() {
  git config --global user.name shintaro-x1
  git config --global user.email suzuki.s@x-point-1.net
}

function git-private() {
  git config --global user.name shintaroasuzuki
  git config --global user.email shinbo.dorapion19971221@gmail.com
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
  nvim
}

#--------------------------
# alias settings
#--------------------------
alias ls="ls -a"
alias git-tree="git ls-tree -r --name-only HEAD | tree --fromfile"
alias s="tmux copy-mode" # "S"croll
alias clear-branch='git branch | grep -v "master\|main\|*" | xargs -r git branch -D'
git config --global alias.tree 'log --graph --all --format="%x09%C(cyan bold)%an%Creset%x09%C(yellow)%h%Creset %C(magenta reverse)%d%Creset %s"'

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
