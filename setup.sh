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
# Install latest LTS Node.js
source ~/.nvm/nvm.sh
nvm install --lts
nvm use --lts

mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/.tigrc ~/.tigrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
