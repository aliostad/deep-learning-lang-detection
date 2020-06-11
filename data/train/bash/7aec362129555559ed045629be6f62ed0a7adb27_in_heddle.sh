#!/bin/bash
IFS=''
let chunk=2048
let i=0
let count=0

function send() {
  local out n h l osum isum e=0 DEFIFS="$IFS"
  IFS=':'
  while true; do
    out="$(echo "$sdata" | base64 -d | dd bs=1 count=$chunk 2>/dev/null | base64 -w 0)"
    osum="$(echo "$i$1:$out" | md5sum | awk '{print $1}')"
    echo "$i$1:$osum:$out"
    #echo "sent: $i$1:$osum:$out" 1>&4
    if read -r -t 2 n h l; then
      #echo "read: $n:$h:$l" 1>&4
      if [ "$n" = "$i$1" ]; then
        l="${l%$'\r'}"
        isum="$(echo "$n:$l" | md5sum | awk '{print $1}')"
        if [ "$isum" = "$h" ]; then
          sdata="$(echo "$sdata" | base64 -d | dd bs=1 skip=$l 2>/dev/null | base64 -w 0)"
          break
        fi
      fi
    fi
    if [ $e -eq 0 ]; then
      echo E 1>&4
      e=1
    fi
    if [ $chunk -gt 4 ]; then
      let chunk/=2
      echo C=$chunk 1>&4
    fi
  done
  IFS="$DEFIFS"
  let i+=1
}

sent=0
while true; do
  if read -r data; then
    # remove escape codes
    data="$(echo "$data" | perl -pe 's/\e\[?.*?[\@-~]//g')"
    echo "$data" 1>&4
    if [ "$data" = "login: $1 (automatic login)"$'\r' ]; then
      python -u -c $'import sys\ns=""\nwhile not s.endswith("Password: "): s+=sys.stdin.read(1)\nsys.stdout.write(s)' 1>&4
      # write password
      python -u -c 'import sys; sys.stdout.write(sys.stdin.readline())' 0<&3
    elif [ "$data" = $'in_heddle\r' ]; then
      if [ $sent -eq 0 ]; then
        echo 'heddle_recv.sh'
        sent=1
      fi
    elif [ "$data" = $'recv_heddle\r' ]; then
      while true; do
        sdata="$(dd bs=1 count=$chunk 0<&3 2>/dev/null | base64 -w 0)"
        if [ -z "$sdata" ]; then
          break
        fi
        let count+=$chunk
        while [ -n "$sdata" ]; do
          send
        done
        echo -n $'\r'$count 1>&4
      done
      send F
      echo 1>&4
    elif [ "$data" = $'reboot: Restarting system\r' ]; then
      break
    fi
  fi
done
