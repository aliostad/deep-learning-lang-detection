#!/bin/bash

if [ -f "dyn.conf" ]; then
  source dyn.conf
else
  echo "no dyn.conf"
  exit 1
fi

mkdir -p $TMP

for repo in $REPO; do
  if [ ! -d "$TARGZDIR/$repo/os/$ARCH" ]; then
    echo "no $TARGZDIR/$repo/os/$ARCH"
    exit
  fi
  if [ -d "$DBDIR/$repo" ]; then
    find $DBDIR/$repo -type f -name '*pkg*' -printf "%f\n" | sort > $TMP/$repo.txt
  else
    mkdir -p $DBDIR/$repo
    : > $TMP/$repo.txt
  fi
  find $TARGZDIR/$repo/os/$ARCH -name "*$ARCH.pkg*" -printf "%f\n" | sort > $TMP/$repo.new.txt
  comm -1 -3 $TMP/$repo.txt $TMP/$repo.new.txt > $TMP/$repo.insert
  comm -2 -3 $TMP/$repo.txt $TMP/$repo.new.txt > $TMP/$repo.delete
done

sync

for repo in $REPO; do
  if [ -s "$TMP/$repo.delete" ]; then
    cd $DBDIR/$repo
    rm $(cat $TMP/$repo.delete)
  fi
done

for repo in $REPO; do
  if [ -s "$TMP/$repo.insert" ]; then
    for pkg in $(cat $TMP/$repo.insert); do
      mkdir -pv $TMP/$pkg
      cd $TMP/$pkg
      tar xf $TARGZDIR/$repo/os/$ARCH/$pkg
      find -type f -print0 | xargs -0 readelf -d 2> /dev/null | awk '
{
  if ($1 == "File:") {
    temp = substr($2,2);
    next;
  }
  if ($1 == "Dynamic") {
    print "FILE", temp
    next;
  }
  if ($2 == "(NEEDED)" || $2 == "(SONAME)" || $2 == "(RPATH)" || $2 == "(RUNPATH)" || $2 == "(NULL)" ) {
    print substr($2,2,length($2)-2), substr($5,2,length($5)-2)
    next;
  }
}' > $DBDIR/$repo/$pkg
    cd $TMP
    rm -rf $TMP/$pkg
    done
  fi
done
