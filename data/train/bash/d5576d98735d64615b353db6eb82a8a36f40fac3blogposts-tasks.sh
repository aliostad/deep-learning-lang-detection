#!/usr/bin/env bash

export BLOGPOSTS_BASEDIR="$(dirname $0)"

if [[ -z $DATUM_CONVERTER ]]; then
  export DATUM_CONVERTER="pandoc"
fi

if [[ -z $DATUM_BASEDIR ]]; then
  export DATUM_BASEDIR="${BLOGPOSTS_BASEDIR}"
fi

if [[ -z $DATUM_REPO ]]; then
  export DATUM_REPO="${BLOGPOSTS_BASEDIR}/.datum-repo~"
fi

fetch-datum-repo(){
  if [[ -d $DATUM_REPO ]]; then
    cd "$DATUM_REPO" && git pull && cd -
  else
    git clone https://github.com/abhishekkr/datum "$DATUM_REPO"
  fi
}

update-blogs(){
   bash "$DATUM_REPO/dat-2-um.sh"
}

fetch-datum-repo
update-blogs

unset BLOGPOSTS_BASEDIR
unset DATUM_CONVERTER
unset DATUM_BASEDIR
unset DATUM_REPO
