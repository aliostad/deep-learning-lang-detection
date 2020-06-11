#! /bin/sh
# Make env setup script
# James Clark, james.clark@ligo.org

# Get the location of the git repository by finding the full path of this file
# and stripping off the name
REPO_PREFIX=`python -c "import os, sys; print os.path.realpath('${0}')" | sed 's|/setup.sh||g'`

# create an etc directory
test -d "${REPO_PREFIX}/etc" || mkdir "${REPO_PREFIX}/etc"


echo "# add script directory to path" > "${REPO_PREFIX}/etc/nrburst-user-env.sh"
echo "export PATH=$REPO_PREFIX/nrburst_utils:$REPO_PREFIX/pca_utils:\$PATH" >> "${REPO_PREFIX}/etc/nrburst-user-env.sh"
echo "export PYTHONPATH=$REPO_PREFIX/nrburst_utils:$REPO_PREFIX/pca_utils:$REPO_PREFIX:\${PYTHONPATH}" >> "${REPO_PREFIX}/etc/nrburst-user-env.sh"

