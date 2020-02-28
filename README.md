# pinutz23 dotfiles
Currently only compatible with macos

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
- [ajmalsiddiqui/dotfiles](https://github.com/ajmalsiddiqui/dotfiles) _(initial inspiration)_
- [natelandau's ist](https://gist.github.com/natelandau/10654137)
- [kdeldycke/dotfiles](https://github.com/kdeldycke/dotfiles) _(additional macOS settings)_
- [keith/dotfiles](https://github.com/keith/dotfiles)