#!/bin/sh

# Script for check remote git repos in the local projects

check_repos()
{
    PROJECT="$1"

    [ "$PROJECT" = "" ] && return 0

    cd_safe "$PROJECTS_DIR/$PROJECT"
    EXIST_REPOS="$(git remote)"
    restore_directory

    for CHECK_REPO in $REMOTE_REPOS
    do
        if [ "$(echo $EXIST_REPOS | grep $CHECK_REPO )" = "" ]
        then
            add_repo "$CHECK_REPO" "$PROJECT"
        fi
    done
}

add_repo()
{
    ADD_REPO="$1"
    PROJECT="$2"

    [ "$ADD_REPO" = "" ] && return 0
    [ "$PROJECT" = "" ] && return 0
    ! is_remote_repo_exist "$ADD_REPO" "$PROJECT" && return 0

    cd_safe "$PROJECTS_DIR/$PROJECT"

    REPO_NAME=$(get_repo_name $ADD_REPO)

    echo "${bldwht}Project $PROJECT - git remote add repo $CHECK_REPO$(tput sgr0)"
    git remote add "$REPO_NAME" "$ADD_REPO$PROJECT.git"
    git fetch "$REPO_NAME"

    restore_directory
}


for CHECK_PROJECT in $PROJECTS
do
    check_repos "$CHECK_PROJECT"
done
