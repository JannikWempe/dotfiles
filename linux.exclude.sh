#!/usr/bin/env bash

# Set up a Debian/Ubuntu (server) machine with my tools and dotfiles.
# Run with sudo from the cloned repo: user-level bits (mise, oh-my-zsh, links,
# docker group) go to the invoking user.
#
#   sudo ./linux.exclude.sh            # tools, docker, shell, dotfiles
#   sudo ./linux.exclude.sh --harden   # + ufw, fail2ban, unattended-upgrades
#
# Idempotent: if a step fails, fix it and simply rerun.

set -e

PROMPT='[linux-setup]'

if [ "$(id -u)" -ne 0 ]; then
	echo "$PROMPT Run me with sudo/as root"
	exit 1
fi

HARDEN=false
case "$1" in
	--harden) HARDEN=true ;;
	'') ;;
	*) echo "$PROMPT Unknown option '$1'. Usage: sudo $0 [--harden]"; exit 1 ;;
esac

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Real user for user-level installs when run via sudo
TARGET_USER="${SUDO_USER:-root}"
TARGET_HOME=$(eval echo "~$TARGET_USER")
MISE="$TARGET_HOME/.local/bin/mise"

as_user () {
	sudo -u "$TARGET_USER" -H "$@"
}

clone_if_missing () {
	[ -d "$2/.git" ] || as_user git clone --depth=1 "$1" "$2"
}

# Gives $ID (debian|ubuntu) and $VERSION_CODENAME, used for the Docker repo
. /etc/os-release

# No interactive dialogs (needrestart, config file prompts) during apt runs
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

apt update -y
apt upgrade -y

# ---------------------------------------------
# Tools I use often
# ---------------------------------------------

echo "$PROMPT Installing CLI tools"

# sudo/curl also needed by the mise and oh-my-zsh installers below.
# build-essential/unzip: mise builds (python, rust) and LazyVim treesitter parsers
apt install -y sudo git vim httpie tree curl ca-certificates gnupg jq \
	zsh tmux fzf fd-find ripgrep bat zoxide eza git-delta gh btop \
	unzip build-essential

# Debian/Ubuntu ship fd and bat under different names
ln -sfn "$(command -v fdfind)" /usr/local/bin/fd
ln -sfn "$(command -v batcat)" /usr/local/bin/bat

# ---------------------------------------------
# Docker
# https://docs.docker.com/engine/install/ubuntu/
# https://docs.docker.com/engine/install/linux-postinstall/
# ---------------------------------------------

echo "$PROMPT Installing Docker"

# Unofficial distro packages conflict with Docker's own
conflicting=$(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc 2>/dev/null | awk '$2 == "install" { print $1 }')
if [ -n "$conflicting" ]; then
	apt remove -y $conflicting
fi

install -m 0755 -d /etc/apt/keyrings
curl -fsSL "https://download.docker.com/linux/$ID/gpg" -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
rm -f /etc/apt/sources.list.d/docker.list # one-line format used by older versions of this script
cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/$ID
Suites: ${UBUNTU_CODENAME:-$VERSION_CODENAME}
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Written before the install so the daemon starts with it; never overwrite local edits.
# - "local" log driver rotates logs (default json-file grows unbounded)
# - Published ports bind to localhost unless an address is given explicitly
#   (-p 0.0.0.0:80:80), because Docker's port publishing bypasses ufw
mkdir -p /etc/docker
if [ ! -f /etc/docker/daemon.json ]; then
	cat > /etc/docker/daemon.json <<'EOF'
{
  "log-driver": "local",
  "ip": "127.0.0.1",
  "default-network-opts": {
    "bridge": {
      "com.docker.network.bridge.host_binding_ipv4": "127.0.0.1"
    }
  }
}
EOF
fi

apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker.service containerd.service

# Docker group = root-equivalent access, takes effect after re-login
groupadd -f docker
usermod -aG docker "$TARGET_USER"
docker version

# ---------------------------------------------
# Dotfiles
# ---------------------------------------------

echo "$PROMPT Linking dotfiles"

# .gitconfig is left out on purpose: it contains macOS-only credential helpers
# and GPG signing. .local/.macos are macOS-only.
for file in .zshrc .p10k.zsh .exports .functions .aliases .vimrc .vimrc.shared .gitignore_global .editorconfig; do
	src="$DOTFILES/$file"
	target="$TARGET_HOME/$file"
	if [ "$(readlink "$target")" = "$src" ]; then
		continue
	fi
	if [ -e "$target" ] || [ -L "$target" ]; then
		if [ -e "$target.bak" ] || [ -L "$target.bak" ]; then
			echo "$PROMPT $target and $target.bak exist, not linking $file"
			continue
		fi
		as_user mv -v "$target" "$target.bak"
	fi
	as_user ln -sv "$src" "$target"
done

as_user "$DOTFILES/link-config.exclude.sh" nvim tmux lazygit mise btop yazi

# ---------------------------------------------
# Shell: zsh + oh-my-zsh (required by .zshrc)
# ---------------------------------------------

echo "$PROMPT Setting up zsh"

if [ ! -d "$TARGET_HOME/.oh-my-zsh" ]; then
	as_user sh -c 'RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
fi
ZSH_CUSTOM="$TARGET_HOME/.oh-my-zsh/custom"
clone_if_missing https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_if_missing https://github.com/zsh-users/zsh-completions.git "$ZSH_CUSTOM/plugins/zsh-completions"
# Sourced by .exports
clone_if_missing https://github.com/junegunn/fzf-git.sh.git "$TARGET_HOME/fzf-git.sh"

# tmux plugin manager + plugins from tmux.conf (plugins dir is gitignored)
TPM="$TARGET_HOME/.config/tmux/plugins/tpm"
[ -f "$TPM/tpm" ] || as_user git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM"
as_user "$TPM/bin/install_plugins" || echo "$PROMPT tmux plugin install failed, press prefix + I inside tmux instead"

chsh -s "$(command -v zsh)" "$TARGET_USER"

# ---------------------------------------------
# Programming Languages and Tools via mise
# ---------------------------------------------

echo "$PROMPT Installing mise tools (this may take a while)"

# Runtimes come from .config/mise/config.toml (shared with macOS).
# Tools that macOS gets from the Brewfile go into the gitignored, machine-local
# config.local.toml; apt's versions are too old or missing.
[ -x "$MISE" ] || as_user sh -c 'curl -fsSL https://mise.run | sh'
as_user "$MISE" use --yes --path "$TARGET_HOME/.config/mise/config.local.toml" \
	neovim@latest lazygit@latest yazi@latest tree-sitter@latest
as_user "$MISE" install --yes

# ---------------------------------------------
# Server hardening (--harden)
# ---------------------------------------------

if [ "$HARDEN" = true ]; then
	echo "$PROMPT Hardening"

	apt install -y ufw fail2ban unattended-upgrades

	# Allow whatever port(s) sshd actually listens on, so we don't lock ourselves out
	ssh_ports=$(sshd -T 2>/dev/null | awk '$1 == "port" { print $2 }')
	for port in ${ssh_ports:-22}; do
		ufw allow "$port/tcp" comment 'ssh'
	done
	ufw --force enable

	# Package defaults enable the sshd jail
	systemctl enable --now fail2ban

	echo 'unattended-upgrades unattended-upgrades/enable_auto_updates boolean true' | debconf-set-selections
	dpkg-reconfigure -f noninteractive unattended-upgrades
fi

apt clean

cat <<EOF

$PROMPT Done. Remaining manual steps:
  - Log out and back in (zsh as default shell, docker group membership)
  - Set up git: copy what you need from $DOTFILES/.gitconfig to ~/.gitconfig
    (osxkeychain/homebrew paths and GPG signing won't work here)
  - gh auth login
  - Open nvim once to let LazyVim install its plugins
EOF
