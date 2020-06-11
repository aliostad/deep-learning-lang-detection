#!/bin/bash

github_user=$(grep -A1 -m1 github ~/.gitconfig |sed '1d;s/ //g' |cut -d= -f2)
github_pw=$(security 2>&1 >/dev/null find-generic-password -gs github.password \
            |ruby -e 'print $1 if STDIN.gets =~ /^password: \"(.*)\"$/')

[ "$1" ] && repo_name=$1; shift || read -p "Name of new repo: " repo_name
[ "$1" ] && repo_desc="$@" || read -p "Description: " repo_desc

json="{\"name\": \"$repo_name\", \"description\": \"$repo_desc\"}"

[ "$github_user" ] && un=$github_user || read -p "Github username: " un
[ "$github_pw" ] && pw=$github_pw || read -s -p "Github password: " pw

create_repo() {
    curl -i -u "$github_user:$github_pw" \
        -d "$json" https://api.github.com/user/repos
}

create_repo
