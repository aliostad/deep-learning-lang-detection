#!/bin/bash
#
# git_combine_repos.sh
#
# Combines several git repositories together into a single repo, 
# preserving branches and history, with each repo in its own subfolder
# of the combined repo.
#
# Usage:
# - Edit REPO_PREFIX and REPO_POSTFIX below as appropriate for your git server.
# - Edit REPONAMES to list the repositories you want to combine.
# - Combined repo will be created locally in the ./combined folder, it's
#   up to you to push it to a server.
#
# Notes:
# - Made for a specific use case, no claims to generality are made
# - Written and tested on OSX, may require modification on non-BSD systems
# - If the git server requires login and you don't have an SSH key set up, 
#   then you'll need to log in interactively once for each repository 
#
# Michael Dewberry 2015/12/2

REPO_PREFIX=username@servername:/path/to/git/
REPO_POSTFIX=.git

REPONAMES="
repo_one
repo_two
repo_three
repo_four
repo_five
"

if [ -e old ]; then
	rm -rf old
fi

if [ -e combined ]; then
	rm -rf combined
fi

rewrite_repo_into_subfolder()
{
	export FILTER_BRANCH_TEMP=`mktemp -dt git-filter-branch`

   	UNIQUE_PREFIX=`cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
   	export SUBFOLDER=${UNIQUE_PREFIX}/$1

	git filter-branch --prune-empty -f -d ${FILTER_BRANCH_TEMP}/step1 --tree-filter '
	if [ ! -e "$SUBFOLDER" ]; then
    	mkdir -p $SUBFOLDER 
    	git ls-tree --name-only $GIT_COMMIT | xargs -I files mv files $SUBFOLDER
	fi' -- --all

	git filter-branch -f -d ${FILTER_BRANCH_TEMP}/step2 --subdirectory-filter $UNIQUE_PREFIX -- --all

	if [ -d "$FILTER_BRANCH_TEMP" ]; then
		rm -rf $FILTER_BRANCH_TEMP
	fi
}

fetch_local_remote_with_all_branches()
{
	export $repo=$1
	git remote add -f $repo ../old/$repo
	branchrefs=()
	refprefix=refs/remotes/${repo}/
	eval "$(git for-each-ref --shell --format='branchrefs+=(%(refname))' refs/remotes/$repo)"
	for branchref in "${branchrefs[@]}"; do
        branch=${branchref#$refprefix}
		echo "*** Creating local branch for ${repo}/${branch}"
    	git branch --track ${repo}-${branch} ${repo}/${branch}
	done
}

mkdir old
cd old

for repo in $REPONAMES
do
	echo "*** Cloning and rewriting repository $repo..."
	mkdir $repo
	cd $repo
	git clone --bare ${REPO_PREFIX}${repo}${REPO_POSTFIX} .git
	git config --bool core.bare false
	git checkout HEAD
	rewrite_repo_into_subfolder $repo
	cd ..
done

cd ..
mkdir combined
cd combined

echo "*** Creating combined repository"
git init

echo "Contains the following repositories from $REPO_PREFIX" > README.md
for repo in $REPONAMES
do
   echo " - $repo" >> README.md
done

git add README.md
git commit -m "Initial commit of combined repo"

for repo in $REPONAMES
do
	echo "*** Fetching local remote with all branches for $repo..."
	fetch_local_remote_with_all_branches $repo
    git merge --no-edit ${repo}-master master 
done

echo "***"
echo "*** Done! Your combined repository is in the ./combined folder."
