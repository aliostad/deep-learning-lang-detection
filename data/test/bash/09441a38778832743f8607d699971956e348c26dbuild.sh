#!/bin/sh -xe

REPO_NAME=lap7-custom-build-from-zero
REPO_BRANCH=master
REPO_USER=clarencep

IMAGE_NAME=$REPO_USER/$REPO_NAME:$REPO_BRANCH

if [ "$REPO_BRANCH" == "master" ]; then
    IMAGE_NAME=$REPO_USER/$REPO_NAME:latest
fi;

docker build -t $IMAGE_NAME .

cat ./check-extensions.php | docker run -i --rm $IMAGE_NAME php

docker run --rm $IMAGE_NAME sh -c '\
    echo ""; \
    echo OS Version; \
    echo --------------; \
    cat /etc/*release;\
    echo ""; \
    echo PHP Version; \
    echo --------------; \
    php -v; \
    echo ""; \
    echo PHP Modules; \
    echo --------------; \
    php -m;' > versions.txt

docker run --rm $IMAGE_NAME php -i > phpinfo.txt


echo "All done."
