# Returns (svn:<revision>:<branch|tag>[*]) if applicable
svn_prompt() {
    if [ -d ".svn" ]; then
        local branch dirty rev info=$(svn info 2>/dev/null)
        branch=$(svn_parse_branch "$info")
        # Uncomment if you want to display the current revision.
        #rev=$(echo "$info" | awk '/^Revision: [0-9]+/{print $2}')
        # Uncomment if you want to display whether the repo is 'dirty.' In some
        # cases (on large repos) this may take a few seconds, which can
        # noticeably delay your prompt after a command executes.
        #[ "$(svn status)" ] && dirty='*'
        if [ "$branch" != "" ] ; then
            echo "(svn:$rev:$branch$dirty)"
        fi
    fi
}

# Returns the current branch or tag name from the given `svn info` output
svn_parse_branch() {
    local chunk url=$(echo "$1" | awk '/^URL: .*/{print $2}')
    echo $url | grep -q "/trunk\b"
    if [ $? -eq 0 ] ; then
        echo trunk
        return
    else
        chunk=$(echo $url | grep -o "/releases.*")
        if [ "$chunk" == "" ] ; then
            chunk=$(echo $url | grep -o "/branches.*")
            if [ "$chunk" == "" ] ; then
                chunk=$(echo $url | grep -o "/tags.*")
            fi
        fi
    fi
    echo $chunk | awk -F/ '{print $3}'
}

