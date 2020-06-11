#!/bin/bash
set -e -x
orgId=${1:-"39928fd4-b86a-36bf-8a06-20932b88ba81"}
sed -ibak "s/39928fd4-b86a-36bf-8a06-20932b88ba81/${orgId}/g" load.js
docker cp load.js $(docker-compose ps -q qube_mongodb):/tmp

docker-compose exec qube_mongodb sh -c "mongo < /tmp/load.js"


if [ -e load.js.private ]; then
sed -ibak "s/39928fd4-b86a-36bf-8a06-20932b88ba81/${orgId}/g" load.js.private
docker cp load.js.private $(docker-compose ps -q qube_mongodb):/tmp
docker-compose exec qube_mongodb sh -c "mongo < /tmp/load.js.private"
fi
set +x