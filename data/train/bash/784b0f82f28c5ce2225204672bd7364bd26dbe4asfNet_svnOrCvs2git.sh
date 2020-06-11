#!/bin/bash
# Copyright: Public Domain (PD)

# immediately exit in case of an error
set -o errexit

# This script does:
# 1. rsync the sf.net SVN repository of tumanako to the local machine
# 2. convert it to a git repository
# 3. remove all binaries from the history of the project
# 4. split the repository into sub-repositories

# CVS
# ---
# This works for a fresh as well as for incremental import from CVS to Git.
# For a nice guide for moving from CVS to Git, see:
# http://www.kernel.org/pub/software/scm/git/docs/gitcvs-migration.html
# includes technical as well as user/usage help and tips

DIR_CWD=$(pwd)
DIR_SCRIPT=$(cd $(dirname $0); pwd)


################################################################################
# Manual vars

PROJECT_NAME=tumanako
#REPO_TYPE=cvs
REPO_TYPE=svn

GITHUB_REPO_USER=tumanako
GITHUB_LOGIN_USER=YOUR_USER
GITHUB_PASSWORD=YOUR_PASSWORD

DO_RSYNCING=1
DO_CONVERSION=1
DO_SUBREPO_PHASE=1
	DO_SPLITTING=1
	DO_FILTERING=1
	DO_CLEANUP=1
	DO_CREATE_GITHUB_REPOS=0

# these get extracted into separate git repositories
subRepoRoots=""
subRepoRoots="${subRepoRoots} bms/web"
subRepoRoots="${subRepoRoots} bms/monitor_linux"
#subRepoRoots="${subRepoRoots} bms/master"
subRepoRoots="${subRepoRoots} bms/slave"
#subRepoRoots="${subRepoRoots} bms/slave_backplane"
subRepoRoots="${subRepoRoots} dashboard/TumanakoDash"
#subRepoRoots="${subRepoRoots} inverter/fw/qpcpp"
subRepoRoots="${subRepoRoots} inverter/fw/motor_control"
subRepoRoots="${subRepoRoots} inverter/fw/bootloader"
subRepoRoots="${subRepoRoots} inverter/fw/Tumanako_QP"
subRepoRoots="${subRepoRoots} inverter/fw/vehicle_control"
subRepoRoots="${subRepoRoots} inverter/fw/lib"
#subRepoRoots="${subRepoRoots} inverter/fw/libopencm3"
subRepoRoots="${subRepoRoots} inverter/fw/STM32MCUtest"
#subRepoRoots="${subRepoRoots} inverter/zz_obsolete/ExpressPCB"
subRepoRoots="${subRepoRoots} inverter/hw/STM32SKAIadaptor"
subRepoRoots="${subRepoRoots} inverter/hw/STM32MCU"
subRepoRoots="${subRepoRoots} inverter/hw/CONTACTOR_BOX"
subRepoRoots="${subRepoRoots} inverter/sw"
subRepoRoots="${subRepoRoots} twiki2mediawiki"

function createBareRepoName {
	# this gets fed one of the relative paths of the list above,
	# e.g. "inverter/fw/lib"
	relRepoPath=$1

	# filter out the last path part, e.g. "lib"
	subRepoNameBare=$(basename "${relRepoPath}")

	echo "${subRepoNameBare}"
}

function createRepoName {
	# this gets fed one of the relative paths of the list above,
	# e.g. "inverter/fw/lib"
	relRepoPath=$1

	# replace '/' with '-'
	subRepoName=tumanako-$(echo "${relRepoPath}" | sed "s#/#-#g" -)

	# do some cleanup
	subRepoName=$(echo "${subRepoName}" | sed "s#monitor_linux#master#g" -)
	subRepoName=$(echo "${subRepoName}" | sed "s#slave_backplane#slaveBackplane#g" -)
	subRepoName=$(echo "${subRepoName}" | sed "s#-TumanakoDash##g" -)
	subRepoName=$(echo "${subRepoName}" | sed "s#_control#Control#g" -)
	subRepoName=$(echo "${subRepoName}" | sed "s#Tumanako_QP#qp#g" -)
	subRepoName=$(echo "${subRepoName}" | sed "s#CONTACTOR_BOX#contactorBox#g" -)

	echo "${subRepoName}"
}
################################################################################


################################################################################
# Automatically set vars (do NOT change by hand!)

MY_ECHO="echo -e"

DIR_REPO_ORIG="${DIR_SCRIPT}/${PROJECT_NAME}_export/orig"
DIR_REPO_RAW="${DIR_SCRIPT}/${PROJECT_NAME}_export/gitRaw"
DIR_REPO_SPLIT="${DIR_SCRIPT}/${PROJECT_NAME}_export/split"
DIR_REPO_FIL="${DIR_SCRIPT}/${PROJECT_NAME}_export/gitFiltered"

AUTHORS_CONV_FILE=${DIR_SCRIPT}/${PROJECT_NAME}_authors.txt
if [ ! -f "${AUTHORS_CONV_FILE}" ]; then
	${MY_ECHO} "Could not find ${REPO_TYPE} to git authors file: ${AUTHORS_CONV_FILE}" 1>&2
	exit 1
fi

if [ "${REPO_TYPE}" = "svn" ]; then
	if [ "$(which svn2git)" = "" ]; then
		${MY_ECHO} "Could not find svn2git; please see install instructions at: https://github.com/nirvdrum/svn2git#readme" 1>&2
		exit 2
	fi
fi

REPO_RSYNC_BASE="${PROJECT_NAME}.${REPO_TYPE}.sourceforge.net::${REPO_TYPE}/${PROJECT_NAME}"
REPO_RSYNC_URL="${REPO_RSYNC_BASE}/*"
################################################################################



################################################################################
# .... action!

mkdir -p "${DIR_REPO_ORIG}"
mkdir -p "${DIR_REPO_RAW}"
mkdir -p "${DIR_REPO_SPLIT}"

# DANGER For a fresh start, you have to delete these directories first.
#rm -Rf "${DIR_REPO_RAW}/*" 2>&1 > /dev/null
#rm -Rf "${DIR_REPO_SPLIT}/*" 2>&1 > /dev/null


# get latest original repository state from sourceforge.net
if [ "${DO_RSYNCING}" = "1" ]; then
	${MY_ECHO} "\n\n"

	${MY_ECHO} "RSYNC with '${REPO_RSYNC_URL}' ..."

	# RSYNC to local dir
	rsync -av "${REPO_RSYNC_URL}" "${DIR_REPO_ORIG}"

	${MY_ECHO} "\n\n"
fi


# Convert to git
if [ "${DO_CONVERSION}" = "1" ]; then
	${MY_ECHO} "\n\n"

	${MY_ECHO} "CONVERT to git ..."

	if [ "${REPO_TYPE}" = "svn" ]; then
		cd "${DIR_REPO_RAW}"
		git init
		svn2git \
			--verbose \
			--metadata \
			"file://${DIR_REPO_ORIG}" \
			--authors "${AUTHORS_CONV_FILE}"
		${MY_ECHO} "raw conversion done!"

		# we do not need this branch, as we have a tag there with the same name already
		git branch -D evd5-backplane-0.2

		# place the local SVN repo URL with the remote/real one
		git filter-branch \
				--force \
				--tag-name-filter "cat" \
				--msg-filter "sed -e 's#file://${DIR_REPO_ORIG}#${REPO_RSYNC_BASE}#' -" \
				-- --all
	else
		# for this to work, you need CVS with server support, which is default on,
		# but not on gentoo; where you might enable it like this:
		# ${MY_ECHO} "dev-util/cvs server" >> /etc/portage/package.use
		# emerge -av dev-util/cvs
		# info about this command:
		# http://www.kernel.org/pub/software/scm/git/docs/git-cvsimport.html
		git cvsimport -v -k -s "_" -a -A ${AUTHORS_CONV_FILE} -d ${DIR_REPO_ORIG} -C ${DIR_REPO_RAW} ${PROJECT_NAME}
	fi

	${MY_ECHO} "\n\n"
fi


# Copy the raw repository, and split it
if [ "${DO_SUBREPO_PHASE}" = "1" ]; then
	${MY_ECHO} "\n\n"

	${MY_ECHO} "SPLIT into sub-repos ..."
	${MY_ECHO} ${subRepoRoots} | sed "s/ /\n/g"
	${MY_ECHO} "\n\n"

	for subRepoRoot in ${subRepoRoots}; do
		${MY_ECHO} "\n\n"

		subRepoNameBare=$(createBareRepoName "${subRepoRoot}")
		subRepoName=$(createRepoName "${subRepoRoot}")
		${MY_ECHO} "START '${subRepoNameBare}' -> '${subRepoName}' ..."
		subRepoPath="${DIR_REPO_SPLIT}/${subRepoName}"

		if [ "${DO_SPLITTING}" = "1" ]; then
			git clone --no-hardlinks "${DIR_REPO_RAW}" "${subRepoPath}"
			cd "${subRepoPath}"

			# we do not to keep linking to the ueber-origin,
			# as it retains no direct relation to the new sub-repository
			git remote rm origin

			# we do not want this tag in the split off repositories
			# (we first create it, to not get an error when removing
			# if it does not exist anymore on this branch)
			git tag -f evd5-backplane-0.2
			git tag -d evd5-backplane-0.2

			# do the splitting off of the sub-path
			git filter-branch --force --subdirectory-filter "${subRepoRoot}" HEAD -- --all

			git remote add origin git@github.com:${GITHUB_REPO_USER}/${subRepoName}.git
		else
			cd "${subRepoPath}"
		fi

		# remove unwanted files (binaries)
		if [ "${DO_FILTERING}" = "1" -a "${subRepoNameBare}" != "qpcpp" -a "${subRepoNameBare}" != "libopencm3" ]; then
			${MY_ECHO} "FILTERING '${subRepoName}'"
			${DIR_SCRIPT}/gitRemoveFilesFromHistory.sh
		fi

		# try to compress the repo a bit
		if [ "${DO_CLEANUP}" = "1" ]; then
			${MY_ECHO} "CLEANUP '${subRepoName}' ..."
			git reset --hard
			git for-each-ref --format="%(refname)" refs/original/ | xargs -r -n 1 git update-ref -d
			git reflog expire --expire=now --all
			git gc --aggressive --prune=now
		fi

		# create the repository on github
		if [ "${DO_CREATE_GITHUB_REPOS}" = "1" -a "${subRepoNameBare}" != "qpcpp" -a "${subRepoNameBare}" != "libopencm3" ]; then
			${MY_ECHO} "CREATING GitHub repository '${subRepoName}'"
			curl -u "${GITHUB_LOGIN_USER}:${GITHUB_PASSWORD}" https://api.github.com/user/repos -d "{\"name\":\"${subRepoName}\"}"
			# NOTE if GITHUB_LOGIN_USER != GITHUB_REPO_USER, then you have to
			#   transfer the repo through the GitHub website (Settings tab),
			#   because the GitHub API does not allow to create for an organization
			#   or to transfer a repo.
		fi

		${MY_ECHO} "DONE with '${subRepoName}'"
		${MY_ECHO} "\n\n"
	done

	${MY_ECHO} "\n\n"
fi


# go back to the directory that originally was the CWD
cd "${DIR_CWD}"
