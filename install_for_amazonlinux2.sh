sudo yum install zsh util-linux-user git gcc gcc-c++ make cmake tmux docker -y
# git clone https://github.com/shintaroasuzuki/dotfiles

# git config
cp dotfiles/.git_credentials.sample ~/.git_credentials

# change shell
sudo chsh -s /bin/zsh ec2-user

# install neovim
cd ~

git clone https://github.com/neovim/neovim

cd neovim

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

cd -

# install nodenv
git clone https://github.com/nodenv/nodenv.git ~/.nodenv

cd ~/.nodenv && src/configure && make -C src

~/.nodenv/bin/nodenv init

mkdir plugins

cd plugins

git clone https://github.com/nodenv/node-build.git

cd ~

# install node
nodenv install 20.14.0
nodenv global 20.14.0

# install pnpm
npm install -g pnpm

# install pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

cd ~/.pyenv && src/configure && make -C src

cd -

# python build dependencies
sudo yum install gcc make patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel

# install python
pyenv install 3.10
pyenv global 3.10

# install uv
pip install uv

# install jenv
git clone https://github.com/jenv/jenv.git ~/.jenv

# install rust
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env

# install zoxide
cargo install zoxide --locked

# install antigen
mkdir -p ~/.antigen
curl -L git.io/antigen > ~/.antigen/antigen.zsh

# install ripgrep
cargo install ripgrep

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# docker config
sudo systemctl start docker
sudo gpasswd -a $(whoami) docker
sudo chgrp docker /var/run/docker.sock
sudo service docker restart
sudo systemctl enable docker

# install docker-compose
sudo mkdir -p /usr/local/lib/docker/cli-plugins
cd /usr/local/lib/docker/cli-plugins
sudo curl -OL https://github.com/docker/compose/releases/download/v2.33.1/docker-compose-linux-x86_64
sudo mv docker-compose-linux-x86_64 docker-compose
sudo chmod +x docker-compose 

# install github cli
type -p yum-config-manager >/dev/null || sudo yum install yum-utils
sudo yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo yum install gh

# symlink
cd dotfiles

CURRENT_DIR=$(pwd)

ln -sfn $CURRENT_DIR/.gitmessage ~/.gitmessage

mkdir -p ~/.config/nvim

sudo rm -rf ~/.config/nvim

ln -sfn $CURRENT_DIR/.config/nvim ~/.config/nvim

ln -sfn $CURRENT_DIR/.zshrc ~/.zshrc

cd -

# reload

source ~/.zshrc

# install claude code
npm install -g @anthropic-ai/claude-code
nodenv rehash

echo "Please restart your shell"
