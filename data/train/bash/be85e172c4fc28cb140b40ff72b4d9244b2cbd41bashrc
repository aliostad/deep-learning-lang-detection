[ -e ~/.targit.yml ] || /opt/load_token

export REPO_DIR="$(cat /.repo_dir)"

function clone() {
    local repo="$1"
    local org="$2"
    if [[ -z "$org" ]] ; then
        org=amylum
    fi
    if [[ -z "$repo" ]] ; then
        echo "Usage: clone repo [org]"
        return
    fi
    if [[ -z "$org" ]] ; then
        org="amylum"
    fi
    local token="$(grep '^targit' ~/.targit.yml | cut -d' ' -f2)"
    local url="https://${USER}:${token}@github.com/${org}/${repo}"
    cd $REPO_DIR
    git clone --recursive "${url}"
    cd $repo
    git config user.name $USER
    cat ~/.gitconfig >> .git/config
    cp ~/.targit.yml ./.github
}

cd $REPO_DIR
