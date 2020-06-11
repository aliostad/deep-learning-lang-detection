#!/bin/bash

# Run in a clean directory passing in a GitHub org, repo and tag/branch name
if [ "$#" -ne 3 ]; then
    echo "bower_deploy.sh <org> <repo> <tag>"
    exit 1
fi

ORG=$1
REPO=$2
BRANCH=$3

MVN_REPO_ID=vendor-releases
MVN_REPO_URL=http://maven-eu.nuxeo.org/nexus/content/repositories/vendor-releases

mkdir $REPO
pushd $_

bower install $ORG/$REPO#$BRANCH
pushd bower_components
zip -r $REPO.zip *
mvn deploy:deploy-file -Dfile=$REPO.zip -DgroupId=$ORG -DartifactId=$REPO -Dversion=$BRANCH -Dpackaging=zip -DrepositoryId=$MVN_REPO_ID -Durl=$MVN_REPO_URL
popd

popd
