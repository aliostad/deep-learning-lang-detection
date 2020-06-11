#!/bin/bash

REPO_PROJECT_TMP_DIR=repo_project_tmp_dir
REPO_STATUS_FILE=repo_status.file
REPO_PROJECT_FILE_PRE=repo_project_file_
REPO_FILTER_STRING=git

# at lichee dir
#	lichee/show_repo_project_modify.sh
#
#	cd lichee
#	./show_repo_project_modify.sh

if [ -d ${REPO_PROJECT_TMP_DIR} ]; then
	rm -rf ${REPO_PROJECT_TMP_DIR}
fi
mkdir ${REPO_PROJECT_TMP_DIR}

if [ -f ./repo/repo ]; then
	./repo/repo forall -p -c "git status" > ${REPO_PROJECT_TMP_DIR}/${REPO_STATUS_FILE}
fi

awk 'BEGIN{RS="\n\n"} {num++} {print > "'$REPO_PROJECT_TMP_DIR'""/""'$REPO_PROJECT_FILE_PRE'"num}' ${REPO_PROJECT_TMP_DIR}/${REPO_STATUS_FILE}

for file in `ls ${REPO_PROJECT_TMP_DIR}/${REPO_PROJECT_FILE_PRE}*`; do
	if grep -q ${REPO_FILTER_STRING} ${file}; then
		cat ${file}
		echo " "
	fi
done

rm -rf ${REPO_PROJECT_TMP_DIR}

