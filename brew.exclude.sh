#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Install homebrew if it is not installed
which brew 1>&/dev/null
if [ ! "$?" -eq 0 ] ; then
	echo "Homebrew not installed. Attempting to install Homebrew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	if [ ! "$?" -eq 0 ] ; then
		echo "Something went wrong. Exiting..." && exit 1
	fi
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Core Utils
brew install coreutils

# Upgrade all outdaed apps installed with brew cask using brew cu
# https://github.com/buo/homebrew-cask-upgrade
brew tap buo/cask-upgrade

# Git (in case this repo isn't already cloned using git)
brew install git

# ---------------------------------------------
# Programming Languages and Frameworks
# ---------------------------------------------

# NodeJS 
brew install node

# Python 3
brew install python
brew install poetry

# ---------------------------------------------
# zsh && oh-my-zsh
# ---------------------------------------------

# zsh
# brew install zsh # pre-installed since catalina
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s $(which zsh)
# clone zsh-autosuggestions && zsh-syntax-highlighting
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
# Add poetry completion; Poetry must be installed first
if [ ! ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/poetry ]; then
	poetry completions zsh > ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/poetry/_poetry
fi
# clone powerlevel10k theme
if [ ! ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# ---------------------------------------------
# Databases
# ---------------------------------------------
brew cask install postgres
brew cask install pgadmin4

# ---------------------------------------------
# Useful tools
# ---------------------------------------------

# Make requests with awesome response formatting
brew install httpie

# Show directory structure with excellent formatting
brew install tree

# code formatting & linting
brew install prettier
brew install eslint
brew install black
brew install flake8

# ---------------------------------------------
# Misc
# ---------------------------------------------

# The Fire Code font
# https://github.com/tonsky/FiraCode
# This method of installation is
# not officially supported, might install outdated version
# Change font in terminal preferences
brew tap caskroom/fonts
brew cask install font-fira-code

brew cask install visual-studio-code

# includes Docker Engine, Docker CLI client, Docker Compose, Notary, Kubernetes, and Credential Helper
# https://docs.docker.com/docker-for-mac/install/#whats-included-in-the-installer
brew cask install docker

brew cask install 1password
brew cask install notion
brew cask install postman

brew cask install dropbox
brew cask install appcleaner
brew cask install vlc
brew cask install whatsapp
brew cask install spotify

# browsers
brew cask install google-chrome
brew cask install brave-browser
brew cask install firefox

# Install more recent versions of some macOS tools.
# brew install vim --with-override-system-vi
brew install grep
brew install openssh

# ---------------------------------------------
# Productivity
# ---------------------------------------------
brew cask install iterm2
brew cask install alfred
brew cask install cheatsheet
brew cask install atext
brew cask install bartender
brew cask install bettertouchtool

# ---------------------------------------------
# Terminal gimmicks xD
# ---------------------------------------------

# The computer fortune teller 
brew install fortune

# The famous cowsay
brew install cowsay

# Multicolored text output
brew install lolcat


# Remove outdated versions from the cellar
brew cleanup
