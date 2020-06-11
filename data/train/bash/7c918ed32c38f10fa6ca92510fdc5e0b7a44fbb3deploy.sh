#!/usr/bin/env bash
docker login -u $DOCKER_USER -p $DOCKER_PASS

export REPO=pageturner/builder
export TAG=`if [ "$TRAVIS_BRANCH" == "master" ]; then echo "latest"; else echo $TRAVIS_BRANCH ; fi`

docker build -f Dockerfile -t $REPO:$TRAVIS_COMMIT .
docker tag $REPO:$TRAVIS_COMMIT $REPO:$TAG
docker tag $REPO:$TRAVIS_COMMIT $REPO:travis-$TRAVIS_BUILD_NUMBER
docker push $REPO

# Export builder containers

builders=("jekyll")

for builder in $builders
do
  repo="pageturner/$builder-builder"

  docker build -f images/$builder/Dockerfile -t $repo:$TRAVIS_COMMIT images/$builder/
  docker tag $repo:$TRAVIS_COMMIT $repo:$TAG
  docker tag $repo:$TRAVIS_COMMIT $repo:travis-$TRAVIS_BUILD_NUMBER
  docker push $repo
done
