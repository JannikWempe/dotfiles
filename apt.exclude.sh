#!/usr/bin/env bash

# Install my favourite tools using apt (works on Debian and Ubuntu)
# Run with sudo: user-level bits (mise, oh-my-zsh, docker group) go to the invoking user.

set -e

PROMPT='[apt-install]'

if [ "$(id -u)" -ne 0 ]; then
	echo "$PROMPT Run me with sudo/as root"
	exit 1
fi

# Real user for user-level installs when run via sudo
TARGET_USER="${SUDO_USER:-root}"
TARGET_HOME=$(eval echo "~$TARGET_USER")

# Gives $ID (debian|ubuntu) and $VERSION_CODENAME, used for the Docker repo
. /etc/os-release

apt update -y
apt upgrade -y

# ---------------------------------------------
# Tools I use often
# ---------------------------------------------

# sudo/curl also needed by the mise and oh-my-zsh installers below
apt install -y sudo git vim httpie tree curl ca-certificates gnupg

# ---------------------------------------------
# Programming Languages and Frameworks
# ---------------------------------------------

# NodeJS (and other runtimes) via mise - see .config/mise/config.toml
# Installs to $TARGET_HOME/.local/bin/mise; .zshrc activates it
sudo -u "$TARGET_USER" sh -c 'curl -fsSL https://mise.run | sh'

# Docker (official repo, keyring method)
install -m 0755 -d /etc/apt/keyrings
curl -fsSL "https://download.docker.com/linux/$ID/gpg" -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$ID $VERSION_CODENAME stable" > /etc/apt/sources.list.d/docker.list
apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -aG docker "$TARGET_USER"
echo "$PROMPT Verifying docker installation using a hello world container..."
docker run --rm hello-world

# ---------------------------------------------
# Misc
# ---------------------------------------------

# Zsh + oh-my-zsh (required by .zshrc) as default shell
apt install -y zsh
if [ ! -d "$TARGET_HOME/.oh-my-zsh" ]; then
	sudo -u "$TARGET_USER" sh -c 'RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
fi
chsh -s "$(command -v zsh)" "$TARGET_USER"

# The Fira Code font
apt install -y fonts-firacode

# My favorite text editor: VS Code
# Installation instructions: https://code.visualstudio.com/docs/setup/linux
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
apt update -y
apt install -y code

# ---------------------------------------------
# Terminal gimmicks xD
# ---------------------------------------------

apt install -y fortune-mod cowsay lolcat

apt clean
