#!/bin/bash

# Install herdr plugins and link plugin configs from this repo. Safe to rerun.
# Note: needs a running, version-matching herdr server (plugin cmds talk to it).

PROMPT='[herdr]'
DIR="$(cd "$(dirname "$0")" && pwd)"

herdr plugin install thanhdat77/herdr-navigator --yes
herdr plugin install JanTvrdik/herdr-command-palette --yes
herdr plugin install devashish2203/herdr-worktrunk --yes

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
