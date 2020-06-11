# source control functions for awesomeness
# 
# i was using aliases but those only work really with one dvcs, so now
# i made them functions so they do the Right Thing (c) whether git or
# mercurial.

# repo types:
#      0	not a repo
#      1	git
#      2	mercurial
get_repo_type () {
    git status 2>/dev/null 1>/dev/null
    if [ 0 -eq $? ]; then
        echo 1
    else
        hg status 2>/dev/null 1>/dev/null
        if [ 0 -eq $? ]; then
            echo 2
        else
            echo 0
        fi
    fi
}

not_a_repo () {
    echo "not a git or mercurial repo!"
}

pull () {
    repo_type=$(get_repo_type)
    if [ "1" = "$repo_type" ]; then
        git pull $@
    elif [ "2" = "$repo_type" ]; then
        hg pull $@
    else
        not_a_repo
    fi
}

push () {
    repo_type=$(get_repo_type)
    if [ "1" = "$repo_type" ]; then
        git push $@
    elif [ "2" = "$repo_type" ]; then
        hg push $@
    else
        not_a_repo
    fi
}

status () {
    repo_type=$(get_repo_type)
    if [ "1" = "$repo_type" ]; then
        git status $@
    elif [ "2" = "$repo_type" ]; then
        hg status $@
    else
        not_a_repo
    fi
}

commit () {
    repo_type=$(get_repo_type)
    if [ "1" = "$repo_type" ]; then
        git commit $@
    elif [ "2" = "$repo_type" ]; then
        hg commit $@
    else
        not_a_repo
    fi
}


st () {
    repo_type=$(get_repo_type)
    if [ "1" = "$repo_type" ]; then
        git status -uno $@
    elif [ "2" = "$repo_type" ]; then
        hg status -mard $@
    else
        not_a_repo
    fi
}

add () {
    repo_type=$(get_repo_type)
    if [ "1" = "$repo_type" ]; then
        git add $@
    elif [ "2" = "$repo_type" ]; then
        hg add $@
    else
        not_a_repo
    fi
}

fetch () {
    repo_type=$(get_repo_type)
    if [ "1" = "$repo_type" ]; then
        echo "git fetch $@"
        git fetch $@
    elif [ "2" = "$repo_type" ]; then
        echo "hg fetch $@"
        hg fetch $@
    else
        not_a_repo
    fi
}

clog () {
    repo_type=$(get_repo_type)
    if [ "1" = "$repo_type" ]; then
        git log $@
    elif [ "2" = "$repo_type" ]; then
        hg log $@ | less
    else
        not_a_repo
    fi
}

checkout () {
    repo_type=$(get_repo_type)
    if [ "1" = "$repo_type" ]; then
        git checkout $@
    elif [ "2" = "$repo_type" ]; then
        hg checkout $@
        if [ $? -ne 0 ]; then
            hg revert $@
        fi
    else
        not_a_repo
    fi
}

co () {
    checkout $@
}

which_dvcs () {
    repo_type=$(get_repo_type)
    if [ "1" = "$repo_type" ]; then
        echo "git"
    elif [ "2" = "$repo_type" ]; then
        echo "mercurial"
    else
        not_a_repo
    fi
}

vcdiff () {
    repo_type=$(get_repo_type)
    if [ "1" = "$repo_type" ]; then
        git diff $@
    elif [ "2" = "$repo_type" ]; then
        hg diff $@ | less
    else
        not_a_repo
    fi
}

vcshelp () {
    echo "supported commands:"
    echo "\tcommit"
    echo "\tadd"
    echo "\tpull"
    echo "\tpush"
    echo "\tcheckout"
    echo "\tfetch"
    echo "\tclog"
    echo "\twhich_dvcs"
    echo "\tvcdiff"
}

git_dump () {
    if [ -z "$1" ]; then
        return
    fi

    branch="$(git status | head -n 1 | awk '{ print $4; }')"
    echo "[+] bundling $branch/HEAD to $1"
    echo

    git bundle create $1 $branch

    filesize="$(ls -lh $1 | awk '{print $5;}' | sed -e '/^$/d')"
    echo
    echo "[+] created $1 at $filesize."
}

git_restore () {
    if [ -z "$1" ]; then
        return
    fi

    branch="$(git status | head -n 1 | awk '{ print $4; }')"
    git remote add bundle $1
    git pull bundle $branch
}

alias lsb='git branch -v'
