#!/bin/sh

URL=<%= cobbler_reposync_url %>
REPO_URL=<%= cobbler_reposync_repo_url %>

COBBLER=/usr/bin/cobbler
if [ ! -x $COBBLER ]; then
    echo "Could not found cobbler"
    exit 1
fi

/bin/sleep `/usr/bin/expr $RANDOM % 300`
$COBBLER reposync --tries=3 --no-fail > /dev/null 2>&1

REPOVIEW=/usr/bin/repoview
if [ ! -x $REPOVIEW ]; then
    echo "Could not found repoview"
    exit 1
fi

REPO_INDEX=/var/www/cobbler/repo_mirror/index.html
if [ -f $REPO_INDEX ]; then
    rm -f $REPO_INDEX
fi

for repo in `$COBBLER repo list`
do
    arch=`$COBBLER repo report --name="$repo" | egrep "Arch.*:.*" | tr -d " " | cut -d ":" -f 2`
    $REPOVIEW -t "$repo - $arch" -u "$URL/cobbler/repo_mirror/$repo/repoview" "/var/www/cobbler/repo_mirror/$repo" -q
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "Failed - \"$repo - $arch\""
    fi

    echo "<a href=\"$REPO_URL/$repo/repoview/\">$repo - $arch</a>" >> $REPO_INDEX
    echo "<br>" >> $REPO_INDEX
done

