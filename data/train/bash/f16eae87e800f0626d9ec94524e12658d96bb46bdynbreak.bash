#!/bin/bash

if [ -f "dyn.conf" ]; then
  source dyn.conf
else
  echo "no dyn.conf"
  exit 1
fi

mkdir -p $TMP

for repo in $REPO; do
  find $DBCLEANDIR/$repo -type f | xargs cat > $TMP/$repo.tutti
  awk '/^SONAME/{print $2}' $TMP/$repo.tutti | sort -u > $TMP/$repo.soname
  awk '/^NEEDED/{print $2}' $TMP/$repo.tutti | sort -u > $TMP/$repo.needed
  awk 'BEGIN{FS="/"} /^FILE .*\.so$/ {print $NF}' $TMP/$repo.tutti | sort -u > $TMP/$repo.so
done

for repo in $REPO; do
  case $repo in
    core)
      tepo="data/all.ignore"
      ;;
    extra)
      tepo="data/all.ignore $TMP/core.soname $TMP/core.so data/core.nosoname"
      ;;
    community)
      tepo="data/all.ignore $TMP/core.soname $TMP/core.so data/core.nosoname $TMP/extra.soname $TMP/extra.so data/extra.nosoname"
      ;;
  esac
  cat $TMP/$repo.so{,name} data/$repo.nosoname $tepo | sort -u > $TMP/$repo.tmp
  comm -2 -3 $TMP/$repo.needed $TMP/$repo.tmp > $TMP/$repo.missing
done

cd $DBCLEANDIR
for repo in $REPO; do
  if [ -s "$TMP/$repo.missing" ]; then
    for missing in $(cat $TMP/$repo.missing); do
      find $repo -type f | xargs grep "^NEEDED $missing$"
    done | sort -u > $PRGDIR/out/$ARCH/$repo.missing-by-pkg.txt
  fi
done
