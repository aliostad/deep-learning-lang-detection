#!/bin/sh

pushd ..

mv repo-install repo-install-rw || exit 1
git clone git://github.com/jpalmucci/repo-install.git repo-install || exit 1

cd .. || exit 1

sudo tar -c --exclude '*~' --exclude '*.fasl' --exclude '*.dx64fsl' -zvf ~/Dropbox/repo-install-bootstrap.tgz \
    repo-install/repo-install  \
    repo-install/asdf  \
    repo-install/trivial-shell \
    repo-install/cl-ppcre  \
    repo-install/cl-fad  || exit 1

cd repo-install || exit 1
rm -rf repo-install || exit 1
mv repo-install-rw repo-install || exit 1

popd || exit 1


