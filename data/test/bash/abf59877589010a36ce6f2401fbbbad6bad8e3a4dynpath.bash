#!/bin/bash

if [ -f "dyn.conf" ]; then
  source dyn.conf
else
  echo "no dyn.conf"
  exit 1
fi

mkdir -p $TMP

cd $DBCLEANDIR
for repo in $REPO; do
  tee >(awk '/^RPATH/{print $2}' | sort -u > $TMP/$repo.rpath) \
      >(awk '/^RUNPATH/{print $2}' | sort -u > $TMP/$repo.runpath) \
      >(awk '/^FILE/{print $2}' | sort -u > $TMP/$repo.files) \
      < <(find $repo -type f | xargs cat 2>&-) > /dev/null
done

sleep 5
sync

for repo in $REPO; do
  egrep -v -e "^/bin/" \
           -e "^/sbin/" \
           -e "^/usr/bin/" \
           -e "^/usr/sbin/" \
           -e "^/lib/" \
           -e "^/usr/lib/" \
           -e "^/usr/src/" \
           -e "^/opt/" \
           $TMP/$repo.files > $PRGDIR/out/$ARCH/$repo.badfhs.txt
done
