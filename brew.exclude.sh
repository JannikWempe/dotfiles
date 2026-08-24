#!/usr/bin/env bash

# Install Homebrew + everything in the Brewfile.

# Install homebrew if it is not installed
if ! command -v brew &>/dev/null; then
	echo "Homebrew not installed. Attempting to install Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
		echo "Something went wrong. Exiting..." && exit 1
	}
fi

brew update
brew upgrade

# Install everything from the Brewfile
brew bundle --file="$(dirname "$0")/Brewfile"

# ---------------------------------------------
# zsh && oh-my-zsh
# ---------------------------------------------

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s "$(which zsh)"
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi
if [ ! -e "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Languages (node, rust, go, ...) via mise — see .config/mise/config.toml
mise install

brew cleanup
