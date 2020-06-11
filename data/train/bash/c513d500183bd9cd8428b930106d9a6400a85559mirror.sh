#!/bin/bash

export HOME=/home/js.chang
export REPO_TARGET=$HOME/repo/android

# <none> uploadManifest <remote_name>
function uploadManifest () {
	(
		cd .repo/manifests;
		git push --tags $REPO_TARGET/platform/manifest.git +refs/remotes/origin/*:refs/heads/$1/*;
	)
}

# <none> uploadProjects <remote_name>
function uploadProjects () {
	repo forall -c 'git push --tags $REPO_TARGET/$REPO_PROJECT.git +refs/remotes/$1/*:refs/heads/$1/* &'
	wait
}

# <none> updateMirrorGit
function updateMirrorGit () {
	repo forall -c 'D=$REPO_TARGET/$REPO_PROJECT.git; [ -d $D ] || git init --bare $D'
}

# <none> packProjects
function packProjects () {
	repo forall -c 'echo $REPO_TARGET/$REPO_PROJECT.git/objects > .git/objects/info/alternates'
	repo forall -c 'git repack -adl &'
	wait
}

#
#	LAP
#
(
	export REPO_LOCAL=$HOME/projects/omap_ics_release;
	cd $REPO_LOCAL;
	repo sync -j 20; echo "########## sync done"

	updateMirrorGit; echo "########## update mirror done"
	uploadManifest "lap"; echo "########## upload manifest done"
	uploadProjects "lap"; echo "########## upload projects done"
	packProjects; echo "########## pack done"
)

#
#	batman
#
(
	export REPO_LOCAL=$HOME/projects/batman;
	cd $REPO_LOCAL;
	repo sync -j 20; echo "########## sync done"

	updateMirrorGit; echo "########## update mirror done"
	uploadManifest "batman"; echo "########## upload manifest done"
	uploadProjects "batman"; echo "########## upload projects done"
	packProjects; echo "########## pack done"
)
