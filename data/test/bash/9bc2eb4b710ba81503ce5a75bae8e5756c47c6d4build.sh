function init_repo {
    local TMP=$1 && shift &&
    echo "cloning repo..." &&
    hg -q clone -U http://hg.sqlalchemy.org/sqlalchemy "$TMP"
}

function build_rev {
    local REPO REV TAG &&
    REPO=$1 && shift &&
    TMP=$1 && shift &&
    TAG=$1 && shift &&
    TAG=$(
        cd "$REPO" &&
        hg tags | grep "$TAG" | cut -d ' ' -f 1 | head -n 1
    ) && [[ -n "$TAG" ]] &&
    (
        echo "checking out $TAG" &&
        cd "$REPO" &&
        hg -q archive -r "$TAG" "$TMP"/"$TAG" &&

        echo "building html" &&
        cd "$TMP/$TAG/doc/build" &&
        perl -p -i -e 's/template_bridge = .*//;' conf.py &&
        sphinx-build -b html . . &> /dev/null
    ) &&
    (
        NAME="SQLAlchemy $(echo $TAG | sed -e 's/rel_//' -e 'y/_/./')" &&
        echo "building docset $NAME" &&
        doc2dash -i src/icon.png -n "$NAME" "$TMP/$TAG/doc/build"
    ) &&
    echo "done"
}

function build {
    local REPO TMP TAG &&
    REPO=$1 && shift &&

    if [[ -z "$REPO" ]]; then
        REPO=$(mktemp -d './source.XXXXXX')

    elif [[ -a "$REPO" && ! -d "$REPO/.hg" ]]; then
        return
    fi

    if [[ ! -a "$REPO/.hg" ]]; then
        echo "cloning repo..." &&
        init_repo "$REPO"
    fi

    TMP=$(cd "$(mktemp -d './source.XXXXXX')" && pwd) &&

    while [[ -n "$1" ]]; do
        build_rev "$REPO" "$TMP" "$1" &&
        shift || return
    done
}

build "$@"
