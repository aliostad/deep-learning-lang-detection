bashrc.update() {
  local path="$1"
  local root="$2"

  if [ -z "$root" ]; then
    touch "$path"
    util.append "$path" '# ls aliases'
    util.append "$path" "alias ll='ls -l'"
    util.append "$path" "alias la='ls -lA'"
    util.append "$path" "alias l='ls -C'"
    util.append "$path"
    util.append "$path" '# editor aliases'
    util.append "$path" "alias n='nano -w'"
    util.append "$path" 'x(){ xed "$@" > /dev/null 2>&1; }'
    util.append "$path"
  else
    sudo touch "$path"
    util.append "$path" '# ls aliases' true
    util.append "$path" "alias ll='ls -l'" true
    util.append "$path" "alias la='ls -lA'" true
    util.append "$path" "alias l='ls -C'" true
    util.append "$path" '' true
    util.append "$path" '# editor aliases' true
    util.append "$path" "alias n='nano -w'" true
  fi
}

bashrc.execute() {
  util.message 'editing .bashrc'
  bashrc.update "$HOME/.bashrc"
  bashrc.update '/root/.bashrc' true
  util.assertContains "$HOME/.bashrc" 'nano'
}
