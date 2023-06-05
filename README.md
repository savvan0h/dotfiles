# dotfiles

## Prerequisite
* Neovim >= 0.9
* Python3
* pylama <= 8 (current coc-pyright does not support new parsable format)
* black
* isort
* nodejs >= 10.12
* eslint
* prettier

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew install neovim
$ brew install python3
$ pip3 install neovim
$ pip install 'pylama<=8' pynvim black isort
$ nvm install 13
$ npm install -g eslint
$ npm install prettier -D --save-exact
```

* ghq
* peco

```
$ brew install ghq
$ brew install peco
```

* bash 4 or later

```
$ brew install bash
$ sudo sh -c 'echo /usr/local/bin/bash >> /etc/shells'
$ chsh -s /usr/local/bin/bash
```

* starship

```
$ brew install starship
```

* exa
* bat

```
$ brew install exa
$ brew install bat
```

## Installation

```
$ cd ~
$ git clone https://github.com/hiroki-sawano/dotfiles.git
$ sh ~/dotfiles/setup.sh
```
