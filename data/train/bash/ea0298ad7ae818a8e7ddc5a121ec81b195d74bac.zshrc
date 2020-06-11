# load zgen
source "${HOME}/.tools/zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/command-not-found
    zgen load zsh-users/zsh-syntax-highlighting
#    zgen load /path/to/super-secret-private-plugin
    zgen load rupa/z # jump to most used directories
    zgen load jimhester/per-directory-history    
    zgen load mafredri/zsh-async # for pure-prompt
    zgen load sindresorhus/pure # prompt    
    # bulk load
#    zgen loadall <<EOPLUGINS
#        zsh-users/zsh-history-substring-search
#        /path/to/local/plugin
#EOPLUGINS
    # ^ can't indent this EOPLUGINS

    # completions
    zgen load zsh-users/zsh-completions src

    # save all to init script
    zgen save
fi


alias y='yaourt'
alias ys='yaourt --noconfirm -S'
alias ssh='TERM=xterm-256color ssh'

export VISUAL="vim"
