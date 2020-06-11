#! /bin/bash
# 
# See LICENSE file This software has a license

EXT="txt"       # YOU have to add this file extension on your flagfiles
SRC="src"       # here YOU submit you flagfiles
MAX_CHUNK=2     # MAX_CHUNK flags to submit at once to the referee bot

# $1 is a file that contains at most $MAX_CHUNK flags to submit. 
# This is just an example!
# You should write this function during the contest. 
function submit () {
  echo "SUBMIT $1"
  nc 127.0.0.1 12345 <<HERE
team: ENOFLAG
$(cat $1)
HERE
}


# internal use
PATH="/bin:/usr/bin"
TMP="tmp"       # dir of temporary flagfiles
STAGED_MD5="staged_md5" # dir of md5 hashes that are in process
STAGED="staged" # working dir of my flagfiles
SUBMIT_COLLECTION="$STAGED/do_not_touch_my_flags_collection"
SUBMIT_CHUNK="$STAGED/do_not_touch_my_flags_chunk"
DONE="done"     # dir of md5 hashes that were submitted 
SAFE="safe"     # dir of processed flagfiles
COUNTER=0
CHUNK_COUNTER=0
FLAG_COUNTER=0
TRASH=".trash"
RESULT="$TRASH/.result"


function cleanup_stage () {
  mv $1 $TRASH/
}
function cleanup_stage_md5 () {
  local i=`echo $1 | tr -Cd "[:digit:]"`
  mv $STAGED_MD5/$i/* $DONE/
  rmdir $STAGED_MD5/$i
}
function split_into_chunks () {
  if [ $COUNTER -ge $MAX_CHUNK ]; then
    CHUNK_COUNTER=$[$CHUNK_COUNTER+1]
    COUNTER=0
  fi
  COUNTER=$[$COUNTER+1]
  FLAG_COUNTER=$[$FLAG_COUNTER+1]
  echo "submitted: $FLAG_COUNTER flags" > $RESULT
  echo $1 >> $SUBMIT_CHUNK.$CHUNK_COUNTER
}
function create_dir_if_not_exist () {
  if [ ! -d $1 ]; then
    mkdir $1
  fi
}

function submit_flags () {
  for chunk in $SUBMIT_CHUNK.*; do
    submit $chunk
    cleanup_stage_md5 $chunk
    cleanup_stage $chunk
  done
}
function create_and_check_submit_file () {
  cat $TMP/*.$EXT | sort | uniq | while read LINE ; do
    MD5=`echo -n $LINE | openssl dgst -md5 `
    if [ ! -d $STAGED_MD5/$CHUNK_COUNTER ]; then
      mkdir $STAGED_MD5/$CHUNK_COUNTER
    fi
    if [[ ! -f $STAGED_MD5/$CHUNK_COUNTER/$MD5 && ! -f $DONE/$MD5 ]]; then
      touch $STAGED_MD5/$CHUNK_COUNTER/$MD5
      split_into_chunks $LINE
    fi
  done
}
function exit_if_no_file () {
  if [ ! `ls -1 $SRC/*.$EXT 2>/dev/null | head -1 ` ]; then
    echo "exit"
    exit 0
  fi
}
function create_all_dir () {
  create_dir_if_not_exist $SRC
  create_dir_if_not_exist $TMP
  create_dir_if_not_exist $STAGED_MD5
  create_dir_if_not_exist $STAGED
  create_dir_if_not_exist $SAFE
  create_dir_if_not_exist $DONE
  create_dir_if_not_exist $TRASH
}

function main () {
  create_all_dir
  exit_if_no_file
  mv $SRC/*.$EXT $TMP

  create_and_check_submit_file
  submit_flags

  mv $TMP/*.$EXT $SAFE
  cat $RESULT
  rm -f $TRASH/*
  #rm -f $TRASH/.*
}

function daemon_main () {
        if [ "$(ls -A $SRC/*.$EXT)" ]; then
            mv $SRC/*.$EXT $TMP
            create_and_check_submit_file
            submit_flags
        
            mv $TMP/*.$EXT $SAFE
            cat $RESULT
            rm -f $TRASH/*
            #rm -f $TRASH/.*
        else
            sleep 10
        fi
}

case $1 in
  --help)
        echo "$0 [--daemon] [--test <file>] 
        --test <file> # Submit flags of the given file. 
        --daemon      # Daemon mode, to run the flag submitter
"
    ;;
  --test )
        if [ -s $2 ]; then
            cat $2 | sort | uniq >$2.test
            submit $2.test
            echo "You should remove $2 and $2.test yourself."
        else
            echo "${2} is empty"
        fi
    ;;
  --daemon)
    create_all_dir
    while [ 1 ]; do
        daemon_main
        sleep 60
        echo "awake, next run.."
    done;
    ;;
    * )
    main
    ;;
esac
