# dotfiles

## Prerequisite
* Neovim
* Python3
* pylava

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew install neovim
$ brew install python3
$ pip3 install neovim
$ pip install pylava
$ pip install pynvim
```

* ghq
* peco

```
$ brew install ghq
$ brew install peco
```

* bash 4 or later

```
brew install bash
sudo sh -c 'echo /usr/local/bin/bash >> /etc/shells'
chsh -s /usr/local/bin/bash
```

* starship

```
brew install starship
```

* exa
* bat

```
brew install exa
brew install bat
```

## Installation
```bash
$ cd ~
$ git clone https://github.com/hiroki-sawano/dotfiles.git
$ sh ~/dotfiles/setup.sh
```
