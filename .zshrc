# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/zshrc.pre.zsh"
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
# goenv config
#--------------------------
eval "$(pyenv init --path)"

#--------------------------
# zsh Configuration
#--------------------------

#---------------------
# Import settings
#---------------------
# Init Antigen
source $HOME/.zsh/antigen.zsh

if [ -e /proc/version ] && grep -iq microsoft /proc/version; then
  OS="wsl"
else
  OS="$($HOME/.misc/get-osdist.sh | sed -n 1P)"
fi
PROFILE_DIR="$HOME/.zsh/profile/$OS.zsh"
if [ -e $PROFILE_DIR ]; then
    source $PROFILE_DIR
fi

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

source $HOME/.zsh/color.zsh
source $HOME/.zsh/alias.zsh
source $HOME/.zsh/util.zsh

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
# bindkey -e
# bindkey "^?"    backward-delete-char
# bindkey "^U"    backward-kill-line

# bindkey '^[[Z' reverse-menu-complete

# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down
# # bindkey "$terminfo[kcuu1]" history-substring-search-up
# # bindkey "$terminfo[kcud1]" history-substring-search-down

# bindkey '^[[L' forward-word

# bindkey '[C' forward-word
# bindkey '[D' backward-word
# bindkey "\e[1;5C" forward-word
# bindkey "\e[1;5D" backward-word
# bindkey "\e[5C" forward-word
# bindkey "\e[5D" backward-word
# bindkey "\e\e[C" forward-word
# bindkey "\e\e[D" backward-word

# unset LC_ALL
# export LC_ALL='en_US.UTF-8'

#----------------
# Completion
#----------------
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
  $HOME/Documents/cl2(N-/)
  $HOME/Development(N-/)
  $cdpath
)
zstyle ':completion:*:cd:*' tag-order local-directories path-directories

zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} m:=_ m:=- m:=.' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:options' description 'yes'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*' use-cache false

export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"

# source $HOME/.zsh/greeting.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -f ~/usr/local/bin/tmux ] && [ $SHLVL = 1 ]; then
  tmux
fi

if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
    source "${HOME}/.iterm2_shell_integration.zsh"
fi

# 初回シェル時のみ tmux実行
[ -f /usr/local/bin/tmux ] && [ $SHLVL = 1 ] && tmux



# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/shintaro/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/shintaro/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/shintaro/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/shintaro/google-cloud-sdk/completion.zsh.inc'; fi

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/zshrc.post.zsh"


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
