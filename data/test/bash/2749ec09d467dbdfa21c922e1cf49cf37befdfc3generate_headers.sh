#!/bin/bash

# This script takes utilities.c and generates a header for it,
# so that you don't need to.

mkdir -p generated

FILE=generated/utility_names.h

DIR=$(dirname $(readlink -f $0)) # Directory script is in
cd $DIR

function save() {
    echo "$@" >> $FILE
}

echo > $FILE

save "#ifndef GENERATED_UTILITY_NAMES_H"
save "#define GENERATED_UTILITY_NAMES_H"
save

for x in $(cat src/utilities/*.c | grep -E "(UTIL|SIMPLE)\(.*\)"); do
    save "${x};"
done

save
save "#endif"


FILE=generated/help.c

echo > $FILE

for x in $(cat src/utilities/*.c | grep -E "(UTIL|SIMPLE)\(.*\)"); do
  NAME="$(echo $x | sed 's/UTIL(//' | sed 's/SIMPLE(//' | sed 's/)$//')"

  OLDIFS="$IFS"
  IFS=$'\n'
  set $(cat src/utilities/*.c | egrep "^ \* $NAME" -A1024 | grep "($NAME)\$" -B1024 | egrep -v "^ \*/|^SIMPLE|^UTIL" | sed 's/^ \*//' | sed 's/^ //')

  FLAGS="NULL"
  OPTS="NULL"

  NAME="$(echo $1 | cut -d ' ' -f 1)"
  if [[ "$(echo $1 | cut -d ' ' -f 1)" != "$(echo $1 | cut -d ' ' -f 2)" ]]; then
    FLAGS="\"$(echo $1 | cut -d ' ' -f 2-)\""
  fi

  HELP="$2"
  OMSG="$3"
  [ -n "$4" ] && OPTS="$4"

  HELP="$(echo $HELP | sed 's/\"/\\\"/g')"
  OPTS="$(echo $OPTS | sed 's/\"/\\\"/g')"

  [[ "$OPTS" != "NULL" ]] && OPTS="\"$OPTS\""

  IFS="$OLDIFS"

  save "HELP(\"$NAME\", $FLAGS,"
  save "     \"$HELP\","
  save "      $OPTS);"
  save
done

