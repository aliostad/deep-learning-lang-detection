#!/bin/bash

REPO_DIR="$1"
REPO_USER="${2:-apache}"
REPO_GROUP="${3:-subversion}"

if [ "x$REPO_DIR" == "x" ]; then
    echo "You must specify a location for the Subversion repository." > /dev/stderr
    exit 1
fi

if [ -d "$REPO_DIR" ]; then
    echo "It looks like a repository already exists at '$REPO_DIR'." > /dev/stderr
    exit 2
fi

svnadmin create --fs-type fsfs "$REPO_DIR" \
    && ln -snf /usr/bin/ufl_webadmin_svn_hook_runner.sh "$REPO_DIR"/hooks/post-commit \
    && mkdir "$REPO_DIR"/hooks/post-commit.d \
    && ln -snf /usr/bin/ufl_webadmin_svn_hook_post_commit_email.pl "$REPO_DIR"/hooks/post-commit.d/ \
    && ln -snf /usr/bin/ufl_webadmin_svn_hook_post_commit_trac.sh "$REPO_DIR"/hooks/post-commit.d/ \
    && ln -snf /usr/bin/ufl_webadmin_svn_hook_runner.sh "$REPO_DIR"/hooks/post-revprop-change \
    && mkdir "$REPO_DIR"/hooks/post-revprop-change.d \
    && ln -snf /usr/bin/ufl_webadmin_svn_hook_post_revprop_change_trac.sh "$REPO_DIR"/hooks/post-revprop-change.d/ \
    && chown -R "$REPO_USER":"$REPO_GROUP" "$REPO_DIR" \
    && find "$REPO_DIR" \
        -not -path "$REPO_DIR/hooks/post-commit" -and -not -path "$REPO_DIR/hooks/post-commit.d*" \
        -and -not -path "$REPO_DIR/hooks/post-revprop-change" -and -not -path "$REPO_DIR/hooks/post-revprop-change.d*" \
        -print0 | xargs -0 chmod o-rwx

if [ $? ]; then
    echo "Subversion repository created at '$REPO_DIR'."
else
    echo "Error creating Subversion repository at '$REPO_DIR'." > /dev/stderr
    exit 3
fi
