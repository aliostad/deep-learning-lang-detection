#!/bin/sh

BASEDIR=/tmp/eterbackup-TD
ETERPACK=$(pwd)/../bin/eterpack

rm -rf $BASEDIR

. ./eterbackup-functions.sh

create_tree $BASEDIR/sample

cd $BASEDIR || exit 1

$ETERPACK update sample packed || exit 1

$ETERPACK update sample packed || exit 1

$ETERPACK update sample packed || exit 1

$ETERPACK update sample packed || exit 1

$ETERPACK update sample packed || exit 1

$ETERPACK check packed || fatal "check failed"

ls -l packed/*.zpaq

echo "Done! OK!"
echo "Please, check and remove $BASEDIR"
#rm -rf $BASEDIR
