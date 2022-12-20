# MacOS dotfiles

## How to use?

- Symlink (`ln -sv [source] [target]`) the required files to their desired destination.
- Run the homebrew script

> **Warning** The below instructions do not work.

[ ] Update the setup script

## Use cases
- setup a new Mac
    - run `.bootstrap.exclude.sh` and `.macos`
- share (git-)aliases accross macos (and linux systems)
    - get `.gitconfig`, `.gitignore_global`, `.aliases` and `.functions`
    - (linux: make sure to exclude macos specific commands)
    - add `.aliases` and `.functions` to systems `.bashrc` or `.zshrc`
- sync dotfiles accross multiple systems
    - if setup using symlinks just pull the latest changes
- change macos settings
    - just execute `.macos`

## Inspirations
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [ajmalsiddiqui/dotfiles](https://github.com/ajmalsiddiqui/dotfiles) _(initial inspiration)_
- [natelandau's ist](https://gist.github.com/natelandau/10654137)
- [kdeldycke/dotfiles](https://github.com/kdeldycke/dotfiles) _(additional macOS settings)_
- [keith/dotfiles](https://github.com/keith/dotfiles)
