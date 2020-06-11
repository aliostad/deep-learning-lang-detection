#!/usr/bin/env bash
# Generates gource custom logs out of multiple repositories.
# Pass the root directory for a bunch of repositories as command line arguments.
# based on https://gist.github.com/derEremit/1347949
# Example:
# <this.sh> /home/gitolite/repositories /home/gitolite/other_repositories

# exit on error
set -e

output_custom_log () {
    # Append to a log the gource custom log for a repo
    local log=$1
    local repo=$2
    local repo_logfile=$(mktemp /tmp/gource.XXXXXX)
    gource --output-custom-log $repo_logfile $repo && EXIT_CODE=0 || EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
        # add an extra parent directory to the path of the files in each project
        # remove the .git or /.git from the end if it is there
        local clean_repo=${repo%.git}
        local clean_repo=${clean_repo%\/}
        # todo: make this optional?
        local clean_repo="g/$(basename $clean_repo)"
        sed -E "s#(.+)\|#\1|${clean_repo}#" $repo_logfile >> $log
    else
        >&2 echo "Failed processing $repo..."
    fi
}

# create a log file sorted by repo
COMBINED_LOG="$(mktemp /tmp/gource.XXXXXX)"
for root_dir in $@; do
    # todo: gource doesn't seem to support bare repos
    # for bare_repo in $(find "$root_dir" -name *.git -type d -prune); do
    #    output_custom_log $COMBINED_LOG $bare_repo
    # done
    for cloned_repo in $(find "$root_dir" -name .git -type d -prune); do
        # pass repo of repo/.git
        output_custom_log $COMBINED_LOG $(dirname $cloned_repo)
    done
done

# sort the log by date and print to stdout
sort -n $COMBINED_LOG

# cleanup the temp file
rm $COMBINED_LOG
