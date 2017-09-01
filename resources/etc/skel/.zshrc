# Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# aliases for MineCraft-Server
# minecraftsrv="./srv/minecraft-server/start.pl"
# alias minecraft-server="$minecraftsrv"
# alias minecraft-server-srv="$minecraftsrv status"
# alias minecraft-server-cmd="$minecraftsrv command"
# alias minecraft-server-reset="$minecraftsrv restart"
# alias minecraft-server-start="$minecraftsrv start"
# alias minecraft-server-stop="$minecraftsrv stop"
# alias minecraft-server-bk="$minecraftsrv backup"
# alias minecraft-server-on="$minecraftsrv startup"
# alias minecraft-server-off="$minecraftsrv stopserver"

# /!\ THEME 
ZSH_THEME="powerlevel9k/powerlevel9k"
POWER_THEME="theme-of-dreame"

POWERLEVEL9K_MODE="awesome-fontconfig"
source $ZSH/oh-my-zsh.sh
source ~/.fonts/*.sh
# Archlinux
# plugins=(git  python virtualenv screen vim-interaction jsontools colorize zsh-autosuggestions)
# plugins=(k tig gitfast colored-man colorize command-not-found cp dirhistory autojump  sudo)
# plugins=(git ubuntu python virtualenv screen vim-interaction jsontools colorize)
plugins=(k tig gitfast archlinux colored-man colorize command-not-found cp dirhistory autojump sudo python virtualenv screen vim-interaction jsontools zsh-syntax-highlighting zsh-autosuggestions)

# /!\ POWERLEVEL9k settings
source $ZSH/custom/themes/power-themes/$POWER_THEME.zsh


