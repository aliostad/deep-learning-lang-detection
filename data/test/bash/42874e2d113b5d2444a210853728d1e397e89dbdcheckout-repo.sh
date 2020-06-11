#!/bin/bash
#
# copyright (c) Karfield Chen
#

# XXX export $REPO_PATH first!
test -z $REPO_PATH &&
    echo "Fatal: no \$REPO_PATH env found!" &&
    exit 0

print_help() {
    cmd=`basename $0`
    echo "$cmd Usage:"
    echo "  $cmd REPO_DIR CHECKOUT_DIR"
    echo "  $cmd -r REPO_DIR -o CHECKOUT_DIR"
    echo "  $cmd [default dirs]"
    echo ""
    echo "    -r, --repo-dir        repo directory, default is $PWD/.repo"
    echo "    -o, --checkout-dir    checkout directory, default is $PWD"
    echo "    -h, --help            print help information"
}

while test $# -gt 0; do
    case $1 in
        -r|--repo-dir)
            test ! -z $repo_dir &&
                print_help &&
                exit 0
            repo_dir=$2
            shift 2
            ;;
        -o|--checkout-dir)
            test ! -z $co_dir &&
                print_help &&
                exit 0
            co_dir=$2
            shift 2
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        -*)
            echo "Illegal option '$1'"
            print_help
            exit 0
            ;;
        *)
            if test -z $repo_dir; then
                test -e $1 &&
                    repo_dir=$1
            else
                print_help
                exit 0
            fi
            if test -z $co_dir; then
                co_dir=$1
            else
                print_help
                exit 0
            fi
            shift 1
            ;;
    esac
done

test -z $repo_dir &&
    repo_dir=./.repo
test -z $co_dir &&
    co_dir=./

if test ! -e $repo_dir; then
    echo "repostory: $repo_dir found"
    exit 0
fi

dotrepo=$co_dir/.repo/
test -e $co_dir &&
    rm -rf $dotrepo

mkdir -p $co_dir
test ! -e $co_dir &&
    echo "no permission to mkdir $co_dir" &&
    exit 0

mkdir -p $dotrepo

relpath=`python -c "import os.path; print os.path.relpath('$repo_dir', '$dotrepo')"`

echo "relative path: $relpath"
repo_subdir=`ls $repo_dir`
for f in $repo_subdir; do
    echo "link $f."
    if test $f == "manifest.xml"; then
        ln -s manifests/default.xml $dotrepo/$f
    else
        ln -s $relpath/$f $dotrepo/$f
    fi
done

repo_util=$REPO_PATH
test -e $dotrepo/repo &&
    repo_util=$dotrepo/repo

repo_main=$repo_util/main.py
repo_ver=`cat $repo_util/repo|grep "^VERSION *= *(.*)"|sed -n 's/.*(\([0-9]*\), *\([0-9]*\)).*/\1.\2/p'`
echo "start to call main.py to checkout the code..."
exec $repo_main --repo-dir=$dotrepo --wrapper-version=$repo_ver \
    --wrapper-path=$repo_util \
    -- sync --local-only

