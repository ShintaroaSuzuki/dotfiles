# dotfiles

## 環境再現手順

## フォントのインストール

下記のフォントをインストールする
[0xProto](https://github.com/0xType/0xProto)
[NerdFonts](https://github.com/romkatv/dotfiles-public/tree/master/.local/share/fonts/NerdFonts)

## dotfiles のクローン

```
$ cd ~

$ git clone https://github.com/shintaroasuzuki/dotfiles.git
```

## powerlevel10k のインストール

```
$ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
```

プロンプト設定は `.p10k.zsh` で管理する。下記の `stow` で
`~/.p10k.zsh` にシンボリックリンクを作成し、`.zshrc` から読み込む。
`.omp/agent/` は `config.yml` のみ追跡し、実行時のロックファイルを
Git と p10k の `gitstatus` の両方で除外する。

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

## Ghostty の外観設定

1. macOS に Ghostty・Swift・uv と、`0xProto`・`MesloLGS NF`・`Hack Nerd Font Mono` をインストールする。
2. 上記の `stow` で Ghostty の設定ファイルとフォント登録スクリプトを配置する。
3. 日本語フォントを登録する。

   ```sh
   uv run ~/.config/ghostty/install-hiragino-fonts.py
   ```

4. Ghostty を起動する。起動済みなら `Cmd+Shift+,` で設定を再読み込みし、新しいウィンドウを開く。

## iPad の環境設定

### Tailscale 経由で SSH 接続する

1. Mac と iPad に [Tailscale](https://tailscale.com/) をインストールし、同じ Tailscale ネットワーク（tailnet）にログインする。
2. Mac の「システム設定 → 一般 → 共有 → リモートログイン」を有効にし、接続に使うユーザーを許可する。
3. iPad に [Rootshell](https://github.com/kitknox/rootshell) をインストールする。
4. 両端末で Tailscale を接続し、Rootshell に SSH 接続先を登録する。
   - ホスト：Mac の Tailscale IP アドレス（Mac で `tailscale ip -4` を実行して確認）、または MagicDNS のホスト名
   - ポート：`22`
   - ユーザー：Mac のユーザー名（Mac で `whoami` を実行して確認）
   - 認証：Mac に登録済みの SSH 鍵、または Mac のログインパスワード（パスワード認証が許可されている場合）
5. 保存した接続先を開く。初回は SSH ホスト鍵のフィンガープリントを Mac 側と照合してから承認する。

Tailscale 経由で macOS 標準の SSH サーバーに接続するため、ルーターのポート開放や `tailscale up --ssh` は不要。
tailnet のアクセス制御を設定している場合は、iPad から Mac の TCP ポート `22` への接続を許可する。

### Rootshell に Ghostty のカラーテーマを読み込む

1. [ghostty-rootshell.theme](.config/ghostty/ghostty-rootshell.theme) を iPad の「ファイル」に保存する。Mac から AirDrop で送るか、GitHub のファイル画面から Raw ファイルをダウンロードする。
2. Rootshell の設定でテーマのインポートを開き、保存したファイルを読み込む。
3. 読み込んだテーマを選択して適用する。タブごとに別のテーマを指定している場合は、そのタブの設定も変更する。

テーマファイルには Ghostty と同じ背景色・文字色・カーソル色・選択背景色・ANSI 16 色を保存している。
フォントやカーソルの透明度などは含まない。Ghostty の配色を変更した場合は、このファイルも更新して再インポートする。

## Karabiner Elements の設定

karabiner-elements を起動し、「Complex Modifications > Add predefined rules > Import more rules from the Internet」をクリックして、「For Japanese （日本語環境向けの設定）」をインポートし、その後、「コマンドキー (左右どちらでも) を単体で押したときに、英数・かなをトグルで切り替える。」を有効化

## Google 日本語入力の設定

環境設定から、スペースの入力を「半角」に変更

## git 関連の設定

### gitconfig の作成

```
$ cp ~/.gitconfig.example ~/.gitconfig
```

### コミットメッセージテンプレートの設定

```
$ git config commit.template ~/.gitmessage -g
```

### GitHub アカウントの認証と切り替え

GitHub CLI をインストール済みであることが前提。`gh auth setup-git` で gh を git の credential helper として設定する。

```
$ gh auth login
$ gh auth setup-git
```

複数アカウントを使い分ける場合は `gh auth login` を繰り返してアカウントを追加したのち、`gh auth switch` で切り替える。

### `gh dash` のインストール

```
$ gh extension install dlvhdr/gh-dash
```

## nvim の設定

### Avante.nvim 用の Anthropic API キーの設定 (必要に応じて)

```
$ cp ~/.config/nvim/.env.example ~/.config/nvim/.env
```

## [collie](https://github.com/AltanS/collie) のインストール

```
$ curl -fsSL https://colliepwa.dev/install.sh | sh
```

### ローカル設定ファイルの作成

VAPID 秘密鍵を Git に含めないため、Git 管理下の `.env.example` をローカル専用の
`.env` にコピーする。`.env` は `.gitignore` で除外されている。

```
$ cp ~/.config/herdr/plugins/config/herdr.collie/.env.example \
    ~/.config/herdr/plugins/config/herdr.collie/.env
$ chmod 600 ~/.config/herdr/plugins/config/herdr.collie/.env
```

### プッシュ通知の有効化

```
$ collie push-keys mailto:you@example.com
$ collie restart
```

スマートフォンで Collie を再読み込みし、「Settings → Notifications」から通知を
有効化して、OS またはブラウザの通知許可を承認する。その後、配信を確認する。

```
$ collie push-test
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

### Claude Code のインストール

```
curl -fsSL https://claude.ai/install.sh | bash
```

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
