function _wd_contains() {
    echo $1 | grep "$2"
}

function _wd_isclean() {
    local output=`git -C $repo status -s`
    [ -z "$output" ]
}

function _wd_each_repo() {
    local repodir=${REPO_DIR:-~/work}

    find $repodir -maxdepth 2 -name .git -type d | sed 's/\/.git//g' | while read repo; do
        $1 $repo
    done
}

function _wd_check() {
    local repo=$1
    
    _wd_isclean $repo && cecho "$repo is clean" $green && return
    
    cecho "$repo has changes:" $yellow
    git -C $repo status -s
}

function _wd_clean() {
    local repo=$1

    if _wd_isclean $repo; then
        cecho -n "Removing clean repo $repo ... " $green
        rm -rf $repo
        cecho OK $green
    fi
}

function wd() {
    local repodir=${REPO_DIR:-~/work}
    local cmd=${1:-check}

    case $cmd in
        check)
            _wd_each_repo "_wd_check"
            ;;
        clean)
            _wd_each_repo "_wd_clean"
            ;;
        *)
            echo "command unknown"
            ;;
    esac
}

function _wd_unload() {
    unset -f wd
}
