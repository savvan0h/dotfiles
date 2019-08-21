# dotfiles

## Prerequisite
* Neovim
* Python3
* pylava

```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew install neovim
$ brew install python3
$ pip3 install neovim
$ pip install pylava
$ pip install pynvim
```

* bash 4 or later

```bash
brew install bash
sudo sh -c 'echo /usr/local/bin/bash >> /etc/shells'
chsh -s /usr/local/bin/bash
```

## Installation
```bash
$ cd ~
$ git clone https://github.com/hiroki-sawano/dotfiles.git
$ sh ~/dotfiles/setup.sh
```
