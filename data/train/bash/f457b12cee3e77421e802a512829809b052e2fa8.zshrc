#!/usr/bin/bash
load() {
PATH="/home/home/.local/bin:$PATH:/home/home/bin"
if [ "$TERM" = "screen" ]; then; TERM=xterm-termite; fi
eval "$(thefuck --alias wth)"
#GRML's EVIL PROMPT FIXER
add-zsh-hook -d precmd prompt_grml_precmd

# Sourced Plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# Sanity
setopt nonomatch

# EMACS
export ALTERNATE_EDITOR=""
export EDITOR=emacsclient

# Aliases
alias vim="emacs"
alias nano=vim
alias k="k -Ah"
alias sudo='sudo -s'
alias grep='ag'
alias emacs="emacsclient -nw"

# Functions
psaux () { pgrep -f "$@" | xargs ps -fp 2>/dev/null; }
lsg   () { ls $1 | grep ${@:2} } 
# emacs () { emacsclient $@ }
# load zgen
source "${HOME}/.zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
  # load oh my zsh
  zgen oh-my-zsh
  zgen load miekg/lean
  zgen load Tarrasch/zsh-functional
  zgen load djui/alias-tips
  zgen load Tarrasch/zsh-bd
  zgen load Tarrasch/zsh-command-not-found
  zgen load Tarrasch/zsh-colors
  zgen load Tarrasch/zsh-autoenv
  zgen load Tarrasch/zsh-i-know
  zgen load Tarrasch/zsh-mcd
  zgen load mollifier/cd-gitroot
  zgen load uvaes/fzf-marks
  zgen load supercrabtree/k
  zgen load willghatch/zsh-cdr
  zgen load denysdovhan/spaceship-zsh-theme spaceship
  zgen save
fi
}

#No time wasting

if [ -z "$TMUX" ]; then;
else
load
#Fix GRML prompt (if wanted) colors
prompt_grml_precmd
fi
