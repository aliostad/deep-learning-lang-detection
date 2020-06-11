#!/bin/bash

set +o posix
shopt -s extglob

die() {
  echo "$@" >&2
  exit 1
}

usage() {
  cat >&2 <<EOF
Usage: $0 [ OPTIONS ] FILENAME | BLOCK-DEVICE
Options:
  -c CHUNK       size of chunks (default: 4194304)
  -d DRIVE-UUID  UUID of existing drive to image (default: creates new drive)
  -n NAME        name for newly created drive (default: basename of FILENAME)
  -o OFFSET      byte offset from which to resume upload (default: 0)
  -s             set drive claim:type parameter as 'shared' - allow multiple
                 simultaneous mounts
  -z             input image is gzipped
EOF
  exit 1
}

if ! type -t curl >/dev/null; then
  die "This tool requires curl, available from http://curl.haxx.se/"
fi

[ -n "$EHURI" ] || die "Please set EHURI=<API endpoint URI>"
[ -n "$EHAUTH" ] || die "Please set EHAUTH=<user uuid>:<secret API key>"

CHUNK=4194304
GUNZIP=0
OFFSET=0
CLAIMTYPE=exclusive
unset DRIVE

while getopts c:d:n:o:sz OPTION; do
  case "$OPTION" in
    c)
      case "$OPTARG" in
        [1-9]*([0-9]))
          CHUNK="$OPTARG"
          ;;
        *)
          usage
          ;;
      esac
      ;;
    d)
      DRIVE="$OPTARG"
      ;;
    n)
      NAME="$OPTARG"
      ;;
    o)
      case "$OPTARG" in
        0|[1-9]*([0-9]))
          OFFSET="$OPTARG"
          ;;
        *)
          usage
          ;;
      esac
      ;;
    s)
      CLAIMTYPE=shared
      ;;
    z)
      GUNZIP=1
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND - 1))
[ $# -eq 1 ] || usage

NAME="${NAME:-`basename "$1"`}"

if [ $GUNZIP -gt 0 ]; then
  SIZES=`gzip -lq "$1" ` || die "$1: Not in gzip format"
  SIZE=`echo $SIZES | cut -f2 -d' '`
  [ "$SIZE" -gt `stat -L -c '%s' "$1"` ] || echo "$1: gzip reports original file size greater than compressed, may be in error" >&2
else
  [ -f "$1" ] && SIZE=`stat -L -c '%s' "$1"`
  [ -b "$1" ] && SIZE=`blockdev --getsize64 "$1"`
  [ -n "$SIZE" ] && [ $SIZE -gt 0 ] || die "$1: No such file or directory"
fi

EHAUTH="user = \"$EHAUTH\""

if [ -n "$DRIVE" ]; then
  echo "Using existing drive $DRIVE"
elif POSTDATA=`echo "name $NAME"; echo "size $SIZE"; echo "claim:type $CLAIMTYPE";` \
  && DRIVE=`curl --data-ascii "$POSTDATA" -K <(echo "$EHAUTH") -f -s \
                 -H 'Content-Type: text/plain' -H 'Expect:' \
                 "${EHURI}drives/create"` \
  && DRIVE=`sed -n 's/^drive  *//p' <<< "$DRIVE"` && [ -n "$DRIVE" ]; then
  echo "Created drive $DRIVE of size $SIZE"
else
  die "Failed to create drive of size $SIZE"
fi

upload() {
  local COUNT=$(((SIZE - OFFSET + CHUNK - 1)/CHUNK))
  echo -n "Uploading $COUNT chunks of $CHUNK bytes: "
  dd bs=$CHUNK count=0 skip=$((OFFSET/CHUNK)) 2>/dev/null
  for ((OFFSET = OFFSET/CHUNK; OFFSET*CHUNK < SIZE; OFFSET++)); do
    head -c $CHUNK | gzip -c \
      | curl --data-binary @- -K <(echo "$EHAUTH") -f -s \
             -H 'Content-Type: application/octet-stream' \
             -H 'Content-Encoding: gzip' -H 'Expect:' \
             "${EHURI}drives/$DRIVE/write/$((OFFSET*CHUNK))"
    [ $? -eq 0 ] && echo -n . && continue || echo E
    cat <<EOF >&2
Failed to write chunk $OFFSET of $COUNT: aborting
Restart with '-d $DRIVE -o $((OFFSET*CHUNK))' to resume the upload
EOF
    exit 1
  done
  read -t 1 -n 1 a && die "Finished transmitting before end of file"
  echo " completed"
}

if [ $GUNZIP -gt 0 ]; then
  gzip -c -d "$1" 2>/dev/null | upload
else
  upload <"$1"
fi
