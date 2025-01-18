#!/usr/bin/env bash

set -ue

if [[ "$(uname)" != "Darwin" ]]; then
  echo "Unsupported system."
  exit 1
fi

xcode-select --install

if [[ -z "$(command -v brew)" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle --file ./Brewfile

# Install nvm(Homebrew installation is not supported)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

mkdir -p ~/.vim/rc
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.vim/rc/dein.toml ~/.vim/rc
ln -sf ~/dotfiles/.vim/rc/dein_lazy.toml ~/.vim/rc

mkdir -p ~/.config/nvim
ln -sf ~/.vim ~/.config/nvim
ln -sf ~/.vimrc ~/.config/nvim/init.vim

ln -sf ~/dotfiles/.config/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
ln -sfn ~/dotfiles/.config/nvim/ftplugin ~/.config/nvim/ftplugin
ln -sf ~/dotfiles/.config/starship.toml ~/.config/starship.toml

ln -sf ~/dotfiles/.tigrc ~/.tigrc

ln -sf ~/dotfiles/.zshrc ~/.zshrc
