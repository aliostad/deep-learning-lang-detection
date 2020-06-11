#!/bin/sh

EOMER_HOME="$(dirname "$0")"/..
export EOMER_HOME

. "${EOMER_HOME}"/etc/common

REPO_NAME="$1"

if [ "${REPO_NAME}" = "" ]; then
	echo "Usage: $(basename $0) project-name"
	exit 1
fi

LOWER_NAME="${REPO_NAME}"

LOWER_NAME="$(echo "${LOWER_NAME}" | perl -pe '$_ = lc;')"
UPPER_NAME="$(echo "${LOWER_NAME}" | perl -pe '$_ = uc;')"
FIRST_NAME="$(echo "${LOWER_NAME}" | perl -pe '$_ = ucfirst;')"

REPO_PATH=/srv/trac
REPO_HOME="${REPO_PATH}"/"${REPO_NAME}"

sudo.sh trac-admin "${REPO_HOME}" initenv "${REPO_NAME}" sqlite:db/trac.db svn /srv/svn/"${REPO_NAME}"

project-update-trac.sh "${REPO_NAME}"
