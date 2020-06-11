#!/bin/zsh
cd '/home/jay/src/rack-oauth2-sample'
tmux start-server

if ! $(tmux has-session -t 'rack-oauth2-sample'); then

tmux set-option base-index 1
tmux new-session -d -s 'rack-oauth2-sample' -n 'editor'



# set up tabs and panes

# tab "editor"

tmux send-keys -t 'rack-oauth2-sample':0 'vim' C-m

tmux splitw -t 'rack-oauth2-sample':0


tmux select-layout -t 'rack-oauth2-sample':0 'main-vertical'



tmux select-window -t 'rack-oauth2-sample':1

fi

if [ -z $TMUX ]; then
    tmux -u attach-session -t 'rack-oauth2-sample'
else
    tmux -u switch-client -t 'rack-oauth2-sample'
fi
