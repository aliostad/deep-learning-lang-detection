#/bin/sh
ROOT_PATH="`pwd`"
PRE_PATH="dataprocessing"
REPOSITORY_PATH="$PRE_PATH/repositories"

LTP_REPO_NAME="ltp"
LTP_REPO_PATH="$REPOSITORY_PATH/$LTP_REPO_NAME"
LTP_REPO_URL="https://github.com/memeda/ltp"

LTPCWS_REPO_NAME="ltpcws"
LTPCWS_REPO_PATH="$REPOSITORY_PATH/$LTPCWS_REPO_NAME"
LTPCWS_REPO_URL="https://github.com/memeda/ltp-cws"

function logging_error()
{
    echo $@ >> /dev/stderr
}

function clone_repository()
{
    repo_path=$1
    repo_url=$2
    git clone $repo_url $repo_path
    if [ $? -eq 0 ]; then
        logging_error "clone `basename $repo_path` repository done." 
    else 
        logging_error "clone `basename $repo_path` repository failed"
        logging_error "Exit!"
        exit 1
    fi
}

function pull_request_repository()
{
    repo_path=$1
    cd $repo_path
    git pull origin master
    local ret=$?
    if [ $ret -ne 0 ];then
        logging_error "pull request `basename $repo_path` error"
    fi
    logging_error "repository `$basename $repo_path` pull request done."
    return $ret
}

function init_repository()
{
    repo_path=$1
    repo_url=$2
    if [ ! -e $repo_path ] ;then
        clone_repository  "$repo_path" "$repo_url"
    else
        cd $repo_path ; git status >/dev/null
        if [ $? -ne 0 ] ; then
            logging_error "repository `basename $repo_path` is damaged . remove it and reclone it!" 
            rm -rf $repo_path
            clone_repository "$repo_path" "$repo_url"
        else 
            logging_error "repository `basename $repo_path` has already ok "
        fi
    fi
    logging_error "repository `basename $repo_path` initialized ." 
    cd "$ROOT_PATH" # may be the dir has been changed 
}


function init_all_repositories()
{
    # first check the dir is exists 
    init_repository $LTP_REPO_PATH $LTP_REPO_URL
    init_repository $LTPCWS_REPO_PATH $LTPCWS_REPO_URL
}


function main()
{
    init_all_repositories
    pull_request_repository $LTP_REPO_PATH
    
}

main
