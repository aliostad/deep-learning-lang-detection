#!/bin/sh

function clone {

	REPO_NAME=$1

    if [ ! -d "$REPO_NAME" ]; then
      git clone git@github.com:tpe-lecture/$REPO_NAME.git
    fi
}

function update {
	REPO_NAME=$1

    cd $REPO_NAME
    git pull origin master
    cd ..
    rsync --exclude=.git --update -raz --delete __template/ $REPO_NAME/
    cd $REPO_NAME
    git add .
    git commit -m "Auto update of repo"
    git push origin master
    cd ..
}

pushd ../../TPE_Repos

rsync --exclude=*-solution -a --delete ../TPE/11_Labs/ __template/


for REPO in {1..40}
do
	if [ "$REPO" -lt "10" ]
	then
    	NAME=repo-0$REPO
    else
    	NAME=repo-$REPO
   	fi

	clone $NAME
	update $NAME
done

popd

