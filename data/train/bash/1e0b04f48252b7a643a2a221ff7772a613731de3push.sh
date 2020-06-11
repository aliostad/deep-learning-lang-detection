#!/bin/sh

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CLIENT=$ROOT/../..
REPO="$ROOT"/data
set -e

if [ -d "$REPO" ]; then
    rm -r $REPO
fi

mkdir $REPO

if [ -d "$REPO/lib" ]; then
    rm -r $REPO/lib
fi

mkdir $REPO/lib
sbt clean test package copy-dependencies

cp $CLIENT/target/scala-*/*.jar $REPO/uploader.jar
cp $CLIENT/target/scala-*/lib/*.jar $REPO/lib/


cp $ROOT/../getdown.txt $REPO

cat $CLIENT/target/scala-*/lib/code.txt >> $REPO/getdown.txt

$ROOT/changelog/changelog.sh
cp $CLIENT/changelog.txt $REPO
java -cp $ROOT/getdown-tools-1.2.jar com.threerings.getdown.tools.Digester $REPO
cd $REPO

for file in `ls | grep -v lib`
do
    s3cmd put --acl-public --guess-mime-type $file s3://replayuploader/getdown/$file
done

cd lib

for file in `ls`
do
    s3cmd put --acl-public --guess-mime-type $file s3://replayuploader/getdown/lib/$file
done

