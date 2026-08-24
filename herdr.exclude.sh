#!/bin/bash

# Install herdr plugins and link plugin configs from this repo. Safe to rerun.
# Note: needs a running, version-matching herdr server (plugin cmds talk to it).

PROMPT='[herdr]'
DIR="$(cd "$(dirname "$0")" && pwd)"

herdr plugin install -y devashish2203/herdr-worktrunk
herdr plugin install -y JanTvrdik/herdr-command-palette
herdr plugin install -y andrewchng/herdr-sessionizer
herdr plugin install -y JannikWempe/herdr-switcharoo

# Plugin configs live in this repo; herdr reads them from plugins/config/<id>.
for cfg in "$DIR/.config/herdr/plugin-config"/*; do
	name="$(basename "$cfg")"
	target="$HOME/.config/herdr/plugins/config/$name"
	if [ -e "$target" ] && [ ! -L "$target" ]; then
		mv -v "$target" "$target.bak"
	fi
	mkdir -p "$HOME/.config/herdr/plugins/config"
	ln -sfnv "$cfg" "$target"
done

echo "$PROMPT Done"
