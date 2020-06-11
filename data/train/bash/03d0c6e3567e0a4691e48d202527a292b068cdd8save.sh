#! /bin/bash

# Path to your FTL
FTL_PATH="/Users/$USER/Library/Application Support/FasterThanLight"

# Path to your savings
SAVE_PATH="/Users/$USER/FTL"

# Default starting tag
TAG=1

usage() {
  echo "usage: $0 list"
  echo "       $0 load <tag>"
  echo "       $0 save [tag]"
  echo "       $0 tag <oldtag> <newtag>"
  echo "       $0 restore"
  exit 1
}

notexist() {
  echo "File $1.sav doesn't exist"
  exit 1
}

alreadyexist() {
  echo "File $1.sav already exists"
  exit 1
}

isnumber() {
  test "$1" && printf '%f' "$1" >/dev/null 2>&1;
}

case $1 in
  "list")
    ls "$SAVE_PATH" | tr '\n' '\n' | grep .sav | grep -v current
  ;;
  "load")
    if [ ! "$2" ]
    then
      usage
    fi
    if [ -f "$SAVE_PATH/$2.sav" ]
    then
      cp -R "$SAVE_PATH/$2.sav" "$FTL_PATH/continue.sav"
      cp -R "$SAVE_PATH/$2.sav" "$SAVE_PATH/current.sav"
    else
      notexist $2
    fi
  ;;
  "save")
    if [ "$2" ]
    then
      if [ -f "$SAVE_PATH/$2.sav" ]
      then
        alreadyexist $2
      else
        isnumber $2 && TAG=$2
      fi
    else
      while [ -f "$SAVE_PATH/$TAG.sav" ]
      do
        TAG=$[$TAG+1]
      done
    fi
    if [ -f "$FTL_PATH/continue.sav" ]
    then
      cp -R "$FTL_PATH/continue.sav" "$SAVE_PATH/$TAG.sav"
      cp -R "$FTL_PATH/continue.sav" "$SAVE_PATH/current.sav"
    else
      notexist "continue.sav"
    fi
  ;;
  "restore")
    if [ -f "$SAVE_PATH/current.sav" ]
    then
      cp -R "$SAVE_PATH/current.sav" "$FTL_PATH/continue.sav"
    else
      notexist "current.sav"
    fi
  ;;
  "tag")
    if [ ! "$2" -o ! "$3" ]
    then
      usage
    fi
    if [ -f "$SAVE_PATH/$2.sav" ]
    then
      if [ -f "$SAVE_PATH/$3.sav" ]
      then
        alreadyexist $3
      fi
      mv "$SAVE_PATH/$2.sav" "$SAVE_PATH/$3.sav"
    else
      notexist $2
    fi
  ;;
  "newgame")
    rm $SAVE_PATH/*
  ;;
  *)
    usage
  ;;
esac
