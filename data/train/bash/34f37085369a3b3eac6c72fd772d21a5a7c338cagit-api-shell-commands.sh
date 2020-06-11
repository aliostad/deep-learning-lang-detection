#------------------#
# Environment Vars #
#------------------#
# GIT_API_TOKEN    #
# GIT_USER         #
#------------------#

function c_git_list_repos
{
	curl -u "${GIT_API_TOKEN}":x-oauth-basic https://api.github.com/user/repos
}

function c_git_push_to_new_repo
{
    if [ -z ${1+x} ] || [ -z ${2+x} ]; then
		echo "c_git_push_to_new_repo expects the first argument to be a repo name, and the second to be the branch that's being moved"
    else
		repoName="${1}"
		branchToMove="${2}"
		git push "git@github.com:${GIT_USER}/${repoName}.git" "${branchToMove}"
	fi
}

function c_git_create_branch
{
    if [ -z ${1+x} ] || [ -z ${2+x} ]; then
		echo "c_git_create_branch requires the first argument to be the repo name and the second argument to be the new branch name.  Optionally a third argument can be the branch name to branch from."
    else
		local branchFrom="master"
		if [ ! -z ${3+x} ]; then
			echo "and here ${3}"
			branchFrom="${3}"
		fi
		local repoName="${1}"
		local newBranchName="${2}"
		local sha=$(curl -s -u "${GIT_API_TOKEN}":x-oauth-basic 'https://api.github.com/repos/olsonpm/'"${repoName}"'/git/refs' | jsawk -q '?ref="refs/heads/'"${branchFrom}"'";' 'return this.object.sha' -a 'return this[0]')
		curl -u "${GIT_API_TOKEN}":x-oauth-basic -d '{"ref": "refs/heads/'"${newBranchName}"'", "sha": "'"${sha}"'" }' 'https://api.github.com/repos/olsonpm/'"${repoName}"'/git/refs'
    fi
}

function c_git_create_repo
{
    if [ -z ${1+x} ]; then
		echo "c_git_create_repo expects a string parameter"
	else
		repoName="${1}"
		httpCode=$(curl -u "${GIT_API_TOKEN}":x-oauth-basic -d '{"name": "'"${repoName}"'"}' https://api.github.com/user/repos -w "%{http_code}" --silent --output /dev/null)
		if [ "${httpCode}" = "201" ]; then
			echo "Successfully created repo '${repoName}'."
		else
			echo "Something odd happened.  Command ran was:"
			echo curl -u "${GIT_API_TOKEN}":x-oauth-basic -d '{"name": "'"${repoName}"'"}' https://api.github.com/user/repos -w "%{http_code}" --silent --output /dev/null
			printf "\nRun it again and display output? [Y/n]: "
			read res
			if [ "${res}" = "Y" ] || [ "${res}" = "y" ]; then
				curl -u "${GIT_API_TOKEN}":x-oauth-basic -d '{"name": "'"${repoName}"'"}' https://api.github.com/user/repos
			fi
		fi
	fi
}

function c_git_clone_repo
{
	if [ -z ${1+x} ]; then
		echo "c_git_clone_repo requires at least a single parameter (repo name).  If two parameters are given, then the first parameter = username, second parameter = repo name"
		return 1
	fi

	local user=''
	local repoName=''
	if [ -z ${2+x} ]; then

        if [[ "${1}" == *"/"* ]]; then
			arrIn=(${1//\// })
			user="${arrIn[0]}"
			repoName="${arrIn[1]}"
		else
			user="${GIT_USER}"
			repoName="${1}"
		fi
	else
		user="${1}"
		repoName="${2}"
	fi

	git clone "git@github.com:${user}/${repoName}.git"
}

function c_git_create_and_clone_repo
{
    if [ -z ${1+x} ]; then
		echo "c_git_create_and_clone_repo expects a string parameter"
	else
		repoName="${1}"
		c_git_create_repo "${repoName}"
		c_git_clone_repo "${repoName}"
	fi
}

function c_git_delete_repo
{
    if [ -z ${1+x} ]; then
		echo "c_git_delete_repo requires a string parameter"
	else
		repoName="${1}"
		echo "About to delete repo: '${repoName}'.  Please re-enter this name to delete the repo."
		read repoName2
		if [ "${repoName}" = "${repoName2}" ]; then
            local deleteFeedback=$(curl -X DELETE -u "${GIT_API_TOKEN}":x-oauth-basic -d '{"name": "'"${repoName}"'"}' https://api.github.com/repos/olsonpm/"${repoName}" 2>&1)
            local success=
            case "${deleteFeedback}" in
                *"\"message\": \"Not Found\""*)
                    success=1
                    ;;
                *)
                    success=0
                    ;;
            esac
            if [ "${success}" = "0" ]; then
                echo "Successfully deleted repo '${repoName}'."
                local repoDir=
                local curDir=$(basename "${PWD}")
                local askedToDelete=1

                # first check pwd to see if the basename matches the repo name
                if [ "${curDir}" = "${repoName}" ]; then
                    askedToDelete="0"
                    printf "The current directory matches the repo name.  Delete it? (Y/n): "
                    read delRepoDir
                    if [ "${delRepoDir}" != "n" ] && [ "${delRepoDir}" != "N" ]; then
                        repoDir="${PWD}"
                        cd ../
                    fi
                else # if pwd doesn't match, then loop through current level directories
                    # ideally we'd set up a while loop and iterate through the directories.  However this is bash where dirty code is king.
                    local dirName=
                    local found="false"
                    for D in */; do
                        dirName=$(basename "${D}")
                        if [ "${dirName}" = "${repoName}" ]; then
                            found="true"
                            break;
                        fi
                    done

                    if [ "${found}" = "true" ]; then
                        askedToDelete="0"
                        printf "A directory was found which matches the repo name '${PWD}/${dirName}'\nDelete it? (Y/n): "
                        read delRepoDir
                        repoDir="${dirName}"
                    fi
                fi

                # if delRepoDir has been assigned (assumed via read) and it equals 'n', then delete the directory
                if [ "${askedToDelete}" = "0" ] && [ "${delRepoDir}" != "n" ] && [ "${delRepoDir}" != "N" ]; then
                    rm -rf "${repoDir}"
                    echo "Successfully deleted directory '${repoDir}'"
                fi

            else
                echo "Error: git repo '${repoName}' was not found"
            fi
		else
			echo "names '${repoName}' and '${repoName2}' did not match.  Now exiting."
		fi
	fi
}

function c_fork_repo
{
    if [ -z ${1+x} ]; then
		echo "c_fork_repo expects a string parameter"
		return 1
	elif [ -z ${2+x} ]; then
		arrIn=(${1//\// })
		owner="${arrIn[0]}"
		repo="${arrIn[1]}"
	else
		owner="${0}"
		repo="${1}"
	fi
	curl -u "${GIT_API_TOKEN}":x-oauth-basic "https://api.github.com/repos/${owner}/${repo}/forks"
}
function c_git_fork_and_clone_repo
{
    if [ -z ${1+x} ]; then
		echo "c_git_fork_and_clone_repo expects a string parameter"
	else
        local newName=""
        local owner=""
        local repo=""
        local arrIn=""

        if [[ "${1}" == *"/"* ]]; then
			arrIn=(${1//\// })
			owner="${arrIn[0]}"
			repo="${arrIn[1]}"

			if [ ! -z ${2+x} ]; then
				newName="${2}"
			fi
        else
			owner="${arrIn[0]}"
			repo="${arrIn[1]}"

			if [ ! -z ${3+x} ]; then
				newName="${3}"
			fi
        fi

		echo "forking repo ${repo}..."
		curl -u "${GIT_API_TOKEN}":x-oauth-basic -d '{"owner": "'"${owner}"'", "repo": "'"${repo}"'"}' "https://api.github.com/repos/${owner}/${repo}/forks" --silent --output /dev/null

		local i=0;
		local success=1
		while [ ${success} -eq 1 ] && [ ${i} -lt 5 ]; do
			sleep 5
			echo "attempting to clone repo '${repo}'"
			__try_clone_repo "${repo}"
			success=$?
			i=$((${i}+1))
		done

		if [ ${success} -eq 1 ]; then
			echo "unable to clone repo '${repo}' after five tries."
		else
			echo "successfully cloned the forked repo '${repo}'."
            if [ "${newName}" != "" ]; then
                cd "./${repo}"
                c_git_rename_repo "${repo}" "${newName}"
            fi
		fi
	fi
}

function c_git_rename_repo
{
    if [ -z ${1+x} ]; then
		echo "c_git_rename_repo requires at least one string parameter ([<old>] <new>)"
	else
        local repoOld=""
        local repoNew=""
        if [ -z ${2+x} ]; then
            repoOld=$(basename $(pwd))
            repoNew="${1}"
        else
            repoOld="${1}"
            repoNew="${2}"
        fi
		local renameFeedback=$(curl -u ${GIT_API_TOKEN}:x-oauth-basic -X PATCH -d '{"name": "'"${repoNew}"'"}' https://api.github.com/repos/olsonpm/${repoOld} 2>&1)
		case "${renameFeedback}" in
			*ERROR*)
				echo "Error occurred while attempting to rename repository: ${renameFeedback}"
				;;
			*"Problems parsing JSON"*)
				echo "Error occurred while attempting to rename repository: ${renameFeedback}"
				;;
			*)
				echo "Successfully renamed repository."
				CWD=$(basename $(pwd));
				if [ "${CWD}" = "${repoOld}" ]; then
					git remote set-url origin "git@github.com:olsonpm/${repoNew}.git"
					echo "successfully changed git remote"
					cd ../
					mv "${repoOld}" "${repoNew}"
					cd "${repoNew}"
					echo "successfully changed directory name"
				fi
				;;
		esac
	fi
}

function __try_clone_repo
{
    if [ -z ${1+x} ]; then
		echo "__try_clone_repo expects a string parameter"
	else
        local repo="${1}"
        local cloneFeedback=$(c_git_clone_repo "${repo}" 2>&1)
		case "${cloneFeedback}" in
			*ERROR*)
				exitStatus=1
				;;
			*"Problems parsing JSON"*)
				exitStatus=1
				;;
			*)
				exitStatus=0
				;;
		esac

		return ${exitStatus};
	fi
}

function gitc
{
    if [ -z ${1+x} ]; then
		echo "gitc expects a string parameter (commit message)"
	else
        msg="${1}"
        git add . && git commit -m "${msg}"
    fi
}

function gitp
{
    if [ -z ${1+x} ]; then
		echo "gitp expects a string parameter (commit message)"
	else
        msg="${1}"
        git add . && git commit -m "${msg}" && git push origin HEAD
    fi
}

function c_git_add_ssh_key
{
    if [ -z ${1+x} ] || [ ! -z ${2+x} ]; then
			echo "c_git_add_ssh_key expects one parameter (title)"
    else
			local title="${1}"
			local key="$(<~/.ssh/id_rsa.pub)"
			curl -H "Authorization: token ${GIT_API_TOKEN}" -d '{"title": "'"${title}"'", "key": "'"${key}"'"}' https://api.github.com/user/keys
    fi
}

export -f c_git_create_repo
export -f c_git_create_branch
export -f c_git_clone_repo
export -f c_git_create_and_clone_repo
export -f c_git_list_repos
export -f c_git_delete_repo
export -f c_git_fork_and_clone_repo
export -f c_git_rename_repo
export -f c_git_add_ssh_key
export -f gitc
export -f gitp
