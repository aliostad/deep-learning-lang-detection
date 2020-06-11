#!/bin/bash

ROOT=$(dirname "$0")
REPO="clixs"
LATEST=$(cat ${ROOT}/latest)
UPDATE=${LATEST%-*}-$(( ${LATEST##*-} + 1 ))
GIT="git add --all .; git commit -m $(basename "$0")_${REPO}_${UPDATE}; git push"

if [ -d "${ROOT}/${REPO}_${LATEST}" ]; then
	echo $LATEST
	echo $UPDATE
	cp -rf "${ROOT}/${REPO}_${LATEST}" "${ROOT}/${REPO}_${UPDATE}"
	echo ${UPDATE} > latest
	ln -sf "${ROOT}/${REPO}_${UPDATE}/usr/local/share/clixs/src/clone-clixs.sh" "${ROOT}/".
	eval "${GIT}"
	echo
	echo "${GIT}"
else
	echo Latest \"${ROOT}/${REPO}_${LATEST}\" missing. 1>&2
	echo Exiting\! 1>&2
	exit 1
fi

