#!/bin/bash

# Install herdr plugins and link plugin configs from this repo. Safe to rerun.
# Note: needs a running, version-matching herdr server (plugin cmds talk to it).

PROMPT='[herdr]'
DIR="$(cd "$(dirname "$0")" && pwd)"

herdr plugin install -y thanhdat77/herdr-navigator
herdr plugin install -y JanTvrdik/herdr-command-palette
herdr plugin install -y devashish2203/herdr-worktrunk

# Link tracked config files while leaving plugin runtime state untracked.
for cfg in "$DIR/.config/herdr/plugin-config"/*; do
	name="$(basename "$cfg")"
	target="$HOME/.config/herdr/plugins/config/$name"
	mkdir -p "$target"
	for file in "$cfg"/*; do
		ln -sfnv "$file" "$target/$(basename "$file")"
	done
done

echo "$PROMPT Done"
