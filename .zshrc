# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="${HOME}/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Docker CLI completions (Docker Desktop generates these; = `docker completion zsh`)
[ -d "$HOME/.docker/completions" ] && fpath=("$HOME/.docker/completions" $fpath)
# fixes compdef not found error
# see: https://stackoverflow.com/a/76900597
autoload -Uz compinit && compinit
if [[ -o interactive ]]; then
  # Load 1Password CLI completions
  eval "$(op completion zsh)"
fi

# Allow auto updates without prompt
DISABLE_UPDATE_PROMPT=true

# show timostamps for `history`
HIST_STAMPS="yyyy-mm-dd"

# See https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
plugins=(
    ### aliases
    brew
    macos
    docker-compose # + autocompletions
    pip # + autocompletions
    aws # + utilities
    # common-aliases # using my own aliases
    # git # using my own aliases
    # npm # using my own aliases

    ### autocompletions
    fd
    ripgrep
    gh
    fzf # + key bindings

    ### tools
    jsontools
    web-search

    # zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions # manually cloned
)
export ZSH_HIGHLIGHT_MAXLENGTH=512

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

source $ZSH/oh-my-zsh.sh

# Source this first since it contains the locations of directories needed by funcitons
source ~/.exports
source ~/.functions
source ~/.aliases

# Initialise zoxide if executable exists
if [ -x "$(command -v zoxide)" ]; then
  # init and use instead of `cd`
  # eval "$(zoxide init --cmd cd zsh)"

  # Zoxide (cd replacement)
  # Only initialize in interactive shells to avoid issues with Claude Code
  [[ $- == *i* ]] && [ -z "$DISABLE_ZOXIDE" ] && eval "$(zoxide init --cmd cd zsh)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh

# pnpm
export PNPM_HOME="/Users/jannik/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

. "$HOME/.local/bin/env"

# add kubectl completion
if [ -x "$(command -v kubectl)" ]; then
  source <(kubectl completion zsh)
fi

# This should be the last line of the file; don't make edits below this
# For local changes
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Activate mise last so its tool paths win over everything above (mise doctor)
[[ -o interactive ]] && eval "$(mise activate zsh)"
