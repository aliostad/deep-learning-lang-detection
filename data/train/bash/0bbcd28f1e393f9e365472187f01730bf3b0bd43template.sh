# Example Apt package repository configuration
#
# See sources.list(5) for legal values.

REPO="myrepo"

# Mirror URL
REPO_MIRROR[$REPO]="http://archive.raspbian.org/raspbian"

# Supported arches
#
# By default, the `$ARCHES` parameter from `base-config.sh`
#REPO_ARCHES[$REPO]="armhf"

# GPG key
#
# This may be a URL, a key fingerprint or a `.gpg` file path.
REPO_KEY[$REPO]="http://archive.raspbian.org/raspbian.public.key"

# Codename
#
# By default, use $DISTRO or $DISTRO_CODENAME
#REPO_CODENAME[$REPO]="wheezy-backports"

# Components
#
# Components provided by repository.  Default is 'main'.
#REPO_COMPONENTS[$REPO]="main universe"

# Base distribution flag
#
# Default "false".  If "true", then this repo can serve as the build
# schroot's base repository.
REPO_IS_BASE[$REPO]="true"

# Package pins
#
# A list of packages in this repo that will be pinned with prio=999.
# This is especially useful for backports.
#REPO_PIN_PACKAGES[$REPO]="cython cython-dbg"
