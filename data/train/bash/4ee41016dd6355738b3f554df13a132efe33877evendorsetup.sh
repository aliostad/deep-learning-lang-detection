function sync() {
	adb shell stop && \
	  adb sync && \
	  adb shell start
}

# Utility script to make sure all projects are checked out to the correctly
# named local branch according to the manifest.
function branchclean() {
	repo forall -c '(git checkout ${REPO_RREV##*/} 1>/dev/null 2>&1 || git checkout -b ${REPO_RREV##*/} ${REPO_REMOTE}/${REPO_RREV##*/} 1>/dev/null 2>&1) || echo "Failed to switch $REPO_PATH to ${REPO_REMOTE}/${REPO_RREV##*/}"'
}

function branchswitch() {
	repo init -b $1 && \
	  branchclean && \
	  repo sync
}

# Modularized by specific products to build product lunch menus and create
# team-specific extensions.
for f in $(/bin/ls vendor/tmobile/products/*/productsetup.sh 2> /dev/null)
do
	echo "including $f"
	. $f
done
unset f
