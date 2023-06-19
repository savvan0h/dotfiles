# dotfiles

## Prerequisite
* Python3
* pylama <= 8 (current coc-pyright does not support new parsable format)
* black
* isort
* nodejs >= 10.12
* eslint
* prettier

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ pip3 install neovim
$ pip install 'pylama<=8' pynvim black isort
$ nvm install 13
$ npm install -g eslint
$ npm install prettier -D --save-exact
```

* bash 4 or later

```
$ brew install bash
$ sudo sh -c 'echo /usr/local/bin/bash >> /etc/shells'
$ chsh -s /usr/local/bin/bash
```

## Installation

```
$ cd ~
$ git clone https://github.com/hiroki-sawano/dotfiles.git
$ sh ~/dotfiles/setup.sh
```
