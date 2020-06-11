function sshcommand() {
    sshpass -p "$XENSERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$XENSERVER_USERNAME"@"$XENSERVER_HOST" "$@"
}

function xecommand() {
    xe -s "$XENSERVER_HOST" -u "root" -pw "$XENSERVER_PASSWORD" "$@"
}

# Function for cloning git repo (if needed)
function fetch_git_repo {
    REPO_URL=$1

    REPO=${REPO_URL##*/}
    REPO_DIR=${REPO%.git}

    if [ ! -d $REPO_DIR ]
    then
        echo "Cloning repo: $REPO_URL"
        git clone $@
    else
        echo "Repo $REPO_URL has already been cloned"
    fi
}
