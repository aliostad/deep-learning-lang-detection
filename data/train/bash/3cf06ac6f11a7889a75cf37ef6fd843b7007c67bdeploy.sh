#!/bin/bash
REPO_URL=https://repo.spring.io/gradle-init-scripts
REPO_USER=buildmaster

if [ $# -eq 0 ]; then
    echo "usage: $0 file1 file2 ..."
    echo "  - each file will be deployed to $REPO_URL"
    echo "  - provide the encrypted password for user '$REPO_USER' when prompted"
    echo "  - shell expansion is allowed, e.g.: $0 *.gradle"
    exit 1
fi

for file in $@; do
    echo "Deploying $file to $REPO_URL/$file"
    curl -XPUT -u$REPO_USER --data-binary @$file "$REPO_URL/$file;artifactory.filtered=true"
    echo ''
done
