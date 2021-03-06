## MODE
## PROMPT_ELEMENTS
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="$(echo "\u256D\u2500")"
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="$(echo "\u2570\u2192")"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon status virtualenv root_indicator context dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(nvm rvm load ram_joined command_execution_time time)
POWERLEVEL9K_PROMPT_ON_NEWLINE="true"
POWERLEVEL9K_RPROMPT_ON_NEWLINE="true"

## ICON CORRECTION
POWERLEVEL9K_FOLDER_ICON="\uf07b"
POWERLEVEL9K_HOME_ICON="\uf286"
POWERLEVEL9K_HOME_SUB_ICON="\uf286 \uf07c"
POWERLEVEL9K_DIR_PATH_SEPARATOR="$(echo "\uf0a9") "
POWERLEVEL9K_OK_ICON="\uf109"
POWERLEVEL9K_FAIL_ICON="\uf0fa"
## JOBS
POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="black"
POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="178"

## CONTEXT 
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="blue"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="245"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="black"

## COMMAND
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0

## OS ICON
POWERLEVEL9K_OS_ICON_BACKGROUND="018"
POWERLEVEL9K_OS_ICON_FOREGROUND="148"

## DIR
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="black"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="249"
POWERLEVEL9K_DIR_HOME_BACKGROUND="018"
POWERLEVEL9K_DIR_HOME_FOREGROUND="220"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="018"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="220"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="015"
POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER="true"
## Status
POWERLEVEL9K_STATUS_OK_BACKGROUND="137"
POWERLEVEL9K_STATUS_OK_FOREGROUND="148"

POWERLEVEL9K_STATUS_ERROR_BACKGROUND="black"
POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"
## NVM
POWERLEVEL9K_NVM_BACKGROUND="238"
POWERLEVEL9K_NVM_FOREGROUND="green"
POWERLEVEL9K_NVM_VISUAL_IDENTIFIER_COLOR="green"
## RVM
POWERLEVEL9K_RVM_BACKGROUND="black"
POWERLEVEL9K_RVM_FOREGROUND="249"
POWERLEVEL9K_RVM_VISUAL_IDENTIFIER_COLOR="red"
## LOAD
POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND="black"
POWERLEVEL9K_LOAD_WARNING_BACKGROUND="black"
POWERLEVEL9K_LOAD_NORMAL_BACKGROUND="black"
POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="249"
POWERLEVEL9K_LOAD_WARNING_FOREGROUND="249"
POWERLEVEL9K_LOAD_NORMAL_FOREGROUND="249"
POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_COLOR="yellow"
POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_COLOR="green"
## RAM
POWERLEVEL9K_RAM_BACKGROUND="black"
POWERLEVEL9K_RAM_FOREGROUND="249"
POWERLEVEL9K_RAM_ELEMENTS=(ram_free)

## TIME
POWERLEVEL9K_TIME_BACKGROUND="255"
POWERLEVEL9K_COMMAND_TIME_FOREGROUND="gray"
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M} \UE12E"



POWERLEVEL9K_SHOW_CHANGESET="true"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

## FUNCTIONS
rule () {
	print -Pn '%F{blue}'
	local columns=$(tput cols)
	for ((i=1; i<=columns; i++)); do
	   printf "\u2588"
	done
	print -P '%f'
}

function _my_clear() {
	echo
	rule
	zle clear-screen
}
zle -N _my_clear
bindkey '^l' _my_clear


# Ctrl-O opens zsh at the current location, and on exit, cd into ranger's last location.
ranger-cd() {
	tempfile=$(mktemp)
	ranger --choosedir="$tempfile" "${@:-$(pwd)}" < $TTY
	test -f "$tempfile" &&
	if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
	cd -- "$(cat "$tempfile")"
	fi
	rm -f -- "$tempfile"
	# hacky way of transferring over previous command and updating the screen
	VISUAL=true zle edit-command-line
}
zle -N ranger-cd
bindkey '^o' ranger-cd
