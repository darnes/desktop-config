
export EDITOR=nvim
# set -o vi

HISTFILE=~/.zsh_history  # Specifies the path to your history file
HISTSIZE=10000           # Maximum number of commands to store in memory
SAVEHIST=10000           # Maximum number of commands to save to the history file

setopt appendhistory        # Appends new history lines to the history file
setopt INC_APPEND_HISTORY   # Incrementally appends history to the file as commands are executed
setopt SHARE_HISTORY        # Shares history between multiple active Zsh sessions
#
# ssh-add ~/.ssh/id_github 2>/dev/null
# keys are added manually in ~/.ssh/config
#
# eval "$(starship init bash)"
eval "$(starship init zsh)"
plugins=( zsh-history-substring-search up-line-or-beginning-search down-line-or-beginning-search)

# alias current_branch='git rev-parse --abbrev-ref HEAD'
# alias git_current_branch='current_branch'
# alias ggp='git push origin $(current_branch)'
alias ggpush='git push origin "$(git_current_branch)"'
# alias ggl='git pull origin $(current_branch)'
alias ggpull='git pull origin "$(git_current_branch)"'

alias k=kubectl

bindkey '^k' autosuggest-accept

# following doesn't really work
# autoload -U up-line-or-beginning-search
# autoload -U down-line-or-beginning-search
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search
# bindkey "^[[A" up-line-or-beginning-search # Up
#bindkey "^[[B" down-line-or-beginning-search # Down
# bindkey "''${key[Up]}" up-line-or-search
#
# fzf in another hand works so much better... 
source <(fzf --zsh)
