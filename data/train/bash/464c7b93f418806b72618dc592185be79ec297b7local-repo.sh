#!/bin/sh
set -x


# settings
REPO_FILE=$(mktemp)

PROD_REPO="${REPOS_DIR}/${VENDOR}/${STREAM_VERSION}/repo"
TEMP_REPO="${REPOS_DIR}/${VENDOR}/${STREAM_VERSION}/$(basename $(mktemp -d --dry-run))"

YUMOPTS="-c $REPO_FILE --disablerepo=* --downloadonly --installroot=$PROD_REPO --downloaddir=$PROD_REPO --enablerepo=mcp"
PACKAGES_FILE=packages.list


# create repo file
printf "[mcp]\nname=mcp\nbaseurl=%s\nenabled=1\ngpgcheck=0\npriority=99\n" \
       "${REPO_BASE_URL}/${VENDOR}/${STREAM_VERSION}/mcp" >> $REPO_FILE


# clean dirty
rm -rf "$PROD_REPO"
mkdir -pv "$PROD_REPO"


# For the development builds, we need to create another temporary repo
# with the just built rpms and that repo needs to have precedence over
# other repos.

# development build
if [ "$USE_SIGNED_PACKAGES" = "false" ]; then

    # create temp repo dir
    if ! test -d "$TEMP_REPO"; then
        mkdir -pv "$TEMP_REPO"
    fi

    # copy pkvm rpms to temp repo
    for f in ${RPMS_BASE_DIR}/${VENDOR}/${STREAM_VERSION}/*.rpm; do
        cp -fv "$f" "$TEMP_REPO"
    done

    # create repodata in temp repo
    createrepo -v "$TEMP_REPO"

    # create temp repo file
    printf "[mcp-temp]\nname=mcp-temp\nbaseurl=%s\nenabled=1\ngpgcheck=0\npriority=1\n" \
           "${REPO_BASE_URL}/${VENDOR}/${STREAM_VERSION}/$(basename $TEMP_REPO)" >> $REPO_FILE

    # adjust YUMOPTS accordingly
    YUMOPTS="$YUMOPTS --enablerepo=mcp-temp"
fi


# Use packages list from git
packages=$(paste -s -d" " $PACKAGES_FILE)


# Download packages to production repo
yum $YUMOPTS repolist -v
yum $YUMOPTS install $packages -y


# Create repo metadata
createrepo -v $PROD_REPO


# Clean up
rm -f $REPO_FILE
rm -rf $TEMP_REPO
rm -rf $PROD_REPO/var


exit 0
