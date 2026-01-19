# dotfiles

## 環境再現手順

## フォントのインストール

下記のフォントをインストールする
[0xProto](https://github.com/0xType/0xProto)
[NerdFonts](https://github.com/romkatv/dotfiles-public/tree/master/.local/share/fonts/NerdFonts)

## dotfiles のクローン

```
$ cd ~

$ git clone https://shintaroasuzuki/dotfiles.git
```

## powerlevel10k のインストール

```
$ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
```

## Homebrew のインストールとパッケージのインストール

### Homebrew のインストール

```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

$ eval "$(/opt/homebrew/bin/brew shellenv)"
```

### パッケージのインストール

```
$ brew bundle --file=~/dotfiles/.Brewfile
```

## dotfiles のシンボリックリンク作成

```
$ cd dotfiles && stow -v -t ~ .
```

## Karabiner Elements の設定

karabiner-elements を起動し、「Complex Modifications > Add predefined rules > Import more rules from the Internet」をクリックして、「For Japanese （日本語環境向けの設定）」をインポートし、その後、「コマンドキー (左右どちらでも) を単体で押したときに、英数・かなをトグルで切り替える。」を有効化

## Google 日本語入力の設定

環境設定から、スペースの入力を「半角」に変更

## tpm (tmux plugin manager) のインストール

```
$ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

prefix + I (大文字の I) を実行すると、tmux のプラグインがインストールされる

## git 関連の設定

### gitconfig の作成

```
$ cp ~/.gitconfig.example ~/.gitconfig
```

### git_credentials の作成

```
$ cp ~/.git_credentials.example ~/.git_credentials
```

GitHub の Personal Access Token を `~/.git_credentials` に記載する

### gitconfig の作成とコミットメッセージテンプレートの設定

```
$ git config commit.template ~/.gitmessage -g
```

### GitHub アカウントの切り替えスクリプトの設定

```
$ source ~/.git_credentials
$ git-private
```

## nvim の設定

### Avante.nvim 用の Anthropic API キーの設定 (必要に応じて)

```
$ cp ~/.config/nvim/.env.example ~/.config/nvim/.env
```

## nb の設定

### notebook の作成とリモートリポジトリの設定

```
$ nb notebooks add <notebook-name>
$ nb use <notebook-name>
$ nb remote set https://github.com/ShintaroaSuzuki/nb-<notebook-name>
```

### semsearch プラグインのインストールと設定

```
$ cd ~/ghq/github.com/ShintaroaSuzuki/nb
$ git clone https://github.com/ShintaroaSuzuki/nb-plugins .plugins
$ cd .plugins/semsearch
$ uv sync
$ nb semindex
```

## Claude の設定

### Claude Code プラグインのインストール

```
$ claude
> /plugin install typescript-lsp@claude-plugins-official
> /plugin install code-simplifier@claude-plugins-official
> /plugin install context7@claude-plugins-official

> /plugin marketplace add https://github.com/ShintaroaSuzuki/shintaroasuzuki-plugins
> /plugin install frontend-design@shintaroasuzuki-plugins
> /plugin install ux-concepts@shintaroasuzuki-plugins
> /plugin install commit-commands@shintaroasuzuki-plugins
> /plugin install codex-collaborator@shintaroasuzuki-plugins

> /plugin marketplace add https://github.com/anthropics/claude-code
> /plugin install ralph-wiggum@claude-code-plugins
> /plugin install security-guidance@claude-code-plugins
> /plugin install pr-review-toolkit@claude-code-plugins
> /plugin install hookify@claude-plugins-official
> /plugin install feature-dev@claude-code-plugins
> /plugin install explanatory-output-style@claude-code-plugins
> /plugin install code-review@claude-code-plugins

> /plugin marketplace add https://github.com/mixedbread-ai/mgrep
> /plugin install mgrep@Mixedbread-Grep
```

## Copilot の設定

### Neovim で Copilot を有効化

```
$ nvim
:Copilot
```

## App Store から購入済みのアプリをインストール
