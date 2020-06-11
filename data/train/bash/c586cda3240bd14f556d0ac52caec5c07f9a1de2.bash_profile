# window aliases
alias absolventa="tmuxifier load-window tmux-windows/absolventa.window.sh"
alias jobnet="tmuxifier load-window tmux-windows/jobnet.window.sh"
alias praktikum-info="tmuxifier load-window tmux-windows/praktikum-info.window.sh"
alias kanyotoku="tmuxifier load-window tmux-windows/kanyotoku.window.sh"
alias trainee-gefluester="tmuxifier load-window tmux-windows/trainee-gefluester.window.sh"
alias interna="tmuxifier load-window tmux-windows/interna.window.sh"

alias coupler="tmuxifier load-window tmux-windows/coupler.window.sh"
alias c3po="tmuxifier load-window tmux-windows/c3po.window.sh"

export PS1='\h:\W \[\033[0;36m\]$(__git_ps1 "[%s] ")\[\033[0m\]\$ '
export LSCOLORS=hefxcxdxbxegedabagacad

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
