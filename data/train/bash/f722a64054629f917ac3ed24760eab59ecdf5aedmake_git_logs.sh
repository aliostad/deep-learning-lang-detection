#!/bin/bash
#
# This script automatically bumps the version of Kogaion
# ebuilds.

. /etc/profile

if [ ${#} -lt 3 ]; then
    echo "${0} <logs dir> <from date> <to date>" >&2
    exit 1
fi

LOGS_DIR="${1}"
FROM_DATE="${2}"
TO_DATE="${3}"
BASE_DIR="${KOGAION_MOLECULE_HOME:-${HOME}}"

GIT_REPOSITORIES=(
    "git://github.com/Rogentos/for-gentoo.git master upstream-overlay"
    "git://github.com/Rogentos/kogaion-distro.git master kogaion-overlay"
    "git://github.com/Rogentos/molecules.git master kogaion-images"
    "git://github.com/Rogentos/entropy.git master entropy"
    "git://github.com/Rogentos/build.git master source-package-builds"
    "git://github.com/Rogentos/anaconda.git master installer"
)

safe_run() {
    for x in $(seq 10); do
        "${@}" && return 0
        sleep 30
    done
    return 1
}

pull_repo() {
    local repo_uri="${1}"
    local repo_branch="${2}"
    local repo_dir="${3}"
    local repo_name="${4}"
    if [ ! -d "${repo_dir}" ]; then
        safe_run git clone "${repo_uri}" "${repo_dir}" || return 1
    else
        (
            cd "${repo_dir}" || exit 1
            safe_run git pull --rebase || exit 1
        ) || return 1
    fi
}

make_log() {
    local repo_dir="${1}"
    local repo_branch="${2}"
    local repo_name="${3}"

    (
        cd "${repo_dir}" || exit 1
        git log --since "${FROM_DATE}" --until "${TO_DATE}" \
            > "${LOGS_DIR}/${repo_name}.log" || exit 1
    ) || return 1
}


bumped=()
for info in "${GIT_REPOSITORIES[@]}"; do
    data=( ${info} )
    repo_uri="${data[0]}"
    repo_branch="${data[1]}"
    repo_name="${data[2]}"
    repos_dir="${BASE_DIR}/automatic-changelogs"
    repo_dir="${repos_dir}/${repo_name}"

    mkdir -p "${repos_dir}" || exit 1
    pull_repo "${repo_uri}" "${repo_branch}" \
        "${repo_dir}" "${repo_name}" || exit 1
    make_log "${repo_dir}" "${repo_branch}" "${repo_name}" || exit 1
done
