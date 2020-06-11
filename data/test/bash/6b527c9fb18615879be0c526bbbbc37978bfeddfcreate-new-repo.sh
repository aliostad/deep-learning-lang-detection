#!/bin/sh
# GH_API_TOKEN=<personal access token> create-new-repo.sh <repo-name>

set -e

usage () {
  echo "Usage: create-new-repo.sh <repo-name>"
  exit 1
}

if [ $# -ne 1 ]; then
  usage
fi

unset SSH_AUTH_SOCK
REPO_NAME="$1"
echo "REPO_NAME: $REPO_NAME"

if [ -z "$GH_API_TOKEN" ]; then
  echo "GH_API_TOKEN unset!"
  exit 1
fi

GH_API="https://api.github.com"

create_repo_payload=$(cat <<EOF
  {
    "name": "$REPO_NAME",
    "description": "test repo created $(date)",
    "private": true,
    "has_issues": false,
    "has_wiki": false,
    "has_downloads": false
  }
EOF
)

curl -i \
     -H "Authorization: token $GH_API_TOKEN" \
     -d "$create_repo_payload" \
     "$GH_API/user/repos"
