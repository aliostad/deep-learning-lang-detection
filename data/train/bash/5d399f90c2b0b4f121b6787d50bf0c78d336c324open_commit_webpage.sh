#!/bin/bash

if [[ -z "$1" ]]; then
	echo "Commit SHA required!"
	exit
fi

# get commit sha from parameter
COMMIT_SHA="$1"

# get repository url using git
REPO_URL=$(git ls-remote --get-url)

# remove ".git" from the end of repository url
REPO_URL="$(echo $REPO_URL | sed -e 's/\.git$//g' )"

# create commit url basing on known repo host:
# Github:
if [[ $REPO_URL =~ github\.com ]]; then 
	COMMIT_URL="$REPO_URL/commit/$COMMIT_SHA"
# Bitbucket:
elif [[ $REPO_URL =~ bitbucket\.org ]]; then 
	COMMIT_URL="$REPO_URL/commits/$COMMIT_SHA"
else
	echo "Unknown repo host: $REPO_URL"
fi

if [[ ! -z "$COMMIT_URL" ]]; then
	# open commit url in browser
	echo "Opening url: $COMMIT_URL"
	open $COMMIT_URL
fi
