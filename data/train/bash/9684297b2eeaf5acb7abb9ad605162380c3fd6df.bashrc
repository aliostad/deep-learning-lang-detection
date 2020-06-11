export TERM=xterm-256color
export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[01;35m\]$(__git_ps1)\[\033[01;34m\] \$\[\033[00m\] '

ssh-add ~/.ssh/dogfood-cw-keypair
ssh-add ~/.ssh/xubuntu-work-rsa

export EDITOR=vim
export HISTTIMEFORMAT="%d/%m/%y %T "

make-secure-deb()
{
  repo=$1
  if [ -z "$repo" ]; then
    echo "Must supply a repo name"
    return 1
  fi
  make deb-only REPO_SERVER=ajh@repo.cw-ngv.com REPO_DIR=www-secure/$repo REPO_DELETE_OLD=Y
}

make-secure-rpm()
{
  repo=$1
  if [ -z "$repo" ]; then
    echo "Must supply a repo name"
    return 1
  fi
  make rpm-only REPO_SERVER=ajh@repo-centos.cw-ngv.com REPO_DIR=www-secure/$repo REPO_DELETE_OLD=Y
}
