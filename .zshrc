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

# Allow auto updates without prompt 
DISABLE_UPDATE_PROMPT=true

HIST_STAMPS="yyyy-mm-dd"

# See https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
plugins=(
    brew
    command-not-found
    # common-aliases # using my own selection of common aliases
    django
    docker
    docker-compose
    gatsby
    # git # using my own git aliases
    # git-flow # using my own git aliases
    gitignore
    jsontools
    pip
    pipenv
    timer
    vscode
    web-search
    zsh_reload
    zsh-autosuggestions
    zsh-syntax-highlighting
    # TODO: one of the follwing:
    # osx
    # ubuntu
)

source $ZSH/oh-my-zsh.sh

# Source this first since it contains the locations of directories needed by funcitons
source .exports
source .functions
source .aliases

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# This should be the last line of the file
# For local changes
# Don't make edits below this
[ -f ".zshrc.local" ] && source ".zshrc.local"