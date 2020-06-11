#!/bin/bash


#### key section

installEpelKey() {
  # Install EPEL gpg key
  rpm -i https://fedoraproject.org/static/0608B895.txt
}

isEpelKeyInstalled() {
  local epelKeyExists="$(rpm -qa gpg* | grep -i 0608B895)"

  # -n = true when val is NOT null
  if [ -n "$epelKeyExists" ]; then
    echo 1
  else
    echo 0
  fi
}



#### repo section

installRepo() {
  rpm -i -K http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
}

isEpelRepoInstalled() {
  local epelRepoFile="/etc/yum.repos.d/epel.repo"

  # -f = true when file exists & is not a dir
  if [ -f $epelRepoFile ]; then
    echo 1
  else
    echo 0
  fi
}



#### main 


# If the repo key is not present, get it
if [[ $(isEpelKeyInstalled) -eq 0 ]]; then
  installEpelKey
fi

# The repo key was not installed? 1) echo the key & repo status, 2) exit
if [[ $(isEpelKeyInstalled) -eq 0 ]]; then
  echo "Epel repo key not Installed"
  if [[ $(isEpelRepoInstalled) -eq 0 ]]; then
    echo "Epel repo not installed-1"
  else
    echo "Epel repo previously installed"
  fi 
  exit
fi


# The repo key was installed, install the repo

installRepo

if [[ $(isEpelRepoInstalled) -eq 0 ]]; then
  echo "Epel repo not installed-2" 
else
  echo "Epel repo installed"
fi

