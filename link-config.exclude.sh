#!/bin/bash

# Symlink configs from ./.config to ~/.config.
# Existing targets are never overridden without confirmation;
# replaced ones are backed up to <name>.bak first.

PROMPT='[link-config]'
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)/.config"
TARGET_DIR="$HOME/.config"

# Apps whose config dir also collects runtime state (logs, sockets, session files)
# on the machine. For these the target stays a real directory and each entry is
# linked individually, so runtime files never end up in this repo.
CONTENTS_APPS='herdr'

usage () {
	cat <<EOF
Usage: $(basename "$0") [app ...]
       $(basename "$0") --help

Symlink configs from this repo's .config/ into ~/.config.

Without arguments, asks per app whether to link it (so machines only set up
what they need). With arguments, links exactly the given apps without asking.

Behavior:
  - Already-linked apps are skipped; rerunning is always safe.
  - Existing configs are never overridden without confirmation; on confirm
    the old config is moved to <name>.bak first. An existing .bak is never
    overwritten.
  - Contents-mode apps ($CONTENTS_APPS): the ~/.config dir stays a real
    directory and each file/dir inside is linked individually, keeping
    runtime files (logs, sockets) out of the repo. After pulling newly
    added files for these apps, rerun this script to link them.

Syncing changes: edits to linked files are picked up via plain git pull on
other machines - no relink needed.

Available apps:
$(ls "$SOURCE_DIR" | sed 's/^/  /')
EOF
}

confirm () {
	echo "$PROMPT $1 (y/n)"
	read -r resp
	[ "$resp" = 'y' ] || [ "$resp" = 'Y' ]
}

# Move $1 to $1.bak; refuses if the backup already exists.
backup_target () {
	local backup="$1.bak"
	if [ -e "$backup" ] || [ -L "$backup" ]; then
		echo "$PROMPT $backup already exists, not overwriting it. Skipping $(basename "$1")"
		return 1
	fi
	mv -v "$1" "$backup"
}

# Symlink $1 to $2, prompting + backing up if $2 exists.
link_one () {
	local src="$1"
	local target="$2"

	if [ "$(readlink "$target")" = "$src" ]; then
		echo "$PROMPT $(basename "$target") already linked, skipping"
		return
	fi

	if [ -e "$target" ] || [ -L "$target" ]; then
		if confirm "$target already exists. Replace it (backup to $(basename "$target").bak)?"; then
			backup_target "$target" || return
		else
			echo "$PROMPT Skipping $(basename "$target")"
			return
		fi
	fi

	ln -sv "$src" "$target"
}

link_app () {
	local name="$1"
	local src="$SOURCE_DIR/$name"
	local target="$TARGET_DIR/$name"

	case " $CONTENTS_APPS " in
		*" $name "*)
			if [ -L "$target" ]; then
				if confirm "$target is a symlink but $name needs a real directory. Replace it (backup to $name.bak)?"; then
					backup_target "$target" || return
				else
					echo "$PROMPT Skipping $name"
					return
				fi
			fi
			mkdir -p "$target"
			for entry in "$src"/*; do
				link_one "$entry" "$target/$(basename "$entry")"
			done
			;;
		*)
			link_one "$src" "$target"
			;;
	esac
}

case "$1" in
	-h|--help)
		usage
		exit 0
		;;
esac

mkdir -p "$TARGET_DIR"

if [ $# -gt 0 ]; then
	for name in "$@"; do
		if [ ! -e "$SOURCE_DIR/$name" ]; then
			echo "$PROMPT Unknown app '$name'. Available: $(ls "$SOURCE_DIR" | tr '\n' ' ')"
			exit 1
		fi
	done
	for name in "$@"; do
		link_app "$name"
	done
else
	for src in "$SOURCE_DIR"/*; do
		name="$(basename "$src")"
		if [ "$(readlink "$TARGET_DIR/$name")" = "$src" ]; then
			echo "$PROMPT $name already linked, skipping"
			continue
		fi
		if confirm "Link $name?"; then
			link_app "$name"
		else
			echo "$PROMPT Skipping $name"
		fi
	done
fi

echo "$PROMPT Done"
