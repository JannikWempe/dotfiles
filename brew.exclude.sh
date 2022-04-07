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
brew install fnm # node version manager

# Python 3
brew install python
brew install poetry

# ---------------------------------------------
# zsh && oh-my-zsh
# ---------------------------------------------

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
if [ ! -e ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/poetry ]; then
	mkdir ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/poetry
	poetry completions zsh > ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/poetry/_poetry
fi
# clone powerlevel10k theme
if [ ! -e ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# ---------------------------------------------
# Useful tools
# ---------------------------------------------

brew install aws
brew install aws-sam-cli

brew install gh

# Make requests with awesome response formatting
brew install httpie

# Process manager
brew install htop

brew install zoxide

# Show directory structure with excellent formatting
brew install exa

# cat with syntax highlighting
brew install bat

brew install tree

# Fuzzy search
brew install fzf
brew install ripgrep

# ---------------------------------------------
# Misc
# ---------------------------------------------

# The Fire Code font
# https://github.com/tonsky/FiraCode
# This method of installation is not officially supported, might install outdated version
# Change font in terminal preferences
brew tap caskroom/fonts
brew install --cask font-fira-code

brew install --cask visual-studio-code
brew install --cask postman

# includes Docker Engine, Docker CLI client, Docker Compose, Notary, Kubernetes, and Credential Helper
# https://docs.docker.com/docker-for-mac/install/#whats-included-in-the-installer
brew install --cask docker

brew install --cask 1password
brew install --cask notion
brew install --cask obsidian
brew install --cask discord
brew install --cask slack

brew install --cask appcleaner
brew install --cask vlc
brew install --cask spotify

brew install --cask stats
brew install --cask keka

brew install --cask obs

# browsers
brew install --cask google-chrome
brew install --cask brave-browser
brew install --cask firefox

# lulu firewall
brew install --cask lulu

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh

# ---------------------------------------------
# Productivity
# ---------------------------------------------
brew install --cask iterm2
brew install --cask alfred
brew install --cask bartender
brew install --cask bettertouchtool
brew install --cask cyberduck

# ---------------------------------------------
# Terminal gimmicks xD
# ---------------------------------------------
brew install fortune
brew install cowsay
brew install lolcat


# Remove outdated versions from the cellar
brew cleanup
