#!/bin/bash
# Migrate SVN to Git repo
#
# Version: 1.0
# Author: Luís Pedro Algargio <lp.algarvio@gmail.com>
#
# http://git-scm.com/docs/git-svn
# http://git-scm.com/book/en/Git-and-Other-Systems-Migrating-to-Git
# http://john.albin.net/git/convert-subversion-to-git
# http://blog.woobling.org/2009/06/git-svn-abandon.html
# http://treyhunner.com/2011/11/migrating-from-subversion-to-git/
# http://stackoverflow.com/questions/2244252/importing-svn-branches-and-tags-on-git-svn
#
# Requires:
#   git-svn-abandon
#     https://github.com/nothingmuch/git-svn-abandon/tree/master
#     Deploy to: /usr/local/git-svn-abandon
#     Symlinks:
#      /usr/local/bin/git-svn-abandon-cleanup    -> /usr/local/git-svn-abandon-master/git-svn-abandon-cleanup
#      /usr/local/bin/git-svn-abandon-fix-refs   -> /usr/local/git-svn-abandon-master/git-svn-abandon-fix-refs
#      /usr/local/bin/git-svn-abandon-msg-filter -> /usr/local/git-svn-abandon-master/git-svn-abandon-msg-filter
#
REPO_ROOT=/srv/repo

# Check if repo URL is not provided
if [ -n "$1" ]; then
  REPO_URL=$1
else
  REPO_URL=https://svn.example.com/svn/myrepo
fi

# Check if repo name is not provided
if [ -n "$2" ]; then
  REPO_NAME=$2
else
  REPO_NAME=myrepo
fi

# Check if repo directory is not provided
if [ -n "$3" ]; then
  REPO_DIR=$REPO_ROOT/$3/$REPO_NAME
else
  REPO_DIR=$REPO_ROOT/example.com/$REPO_NAME
fi

# System variables
TEXT_BOLD=`tput bold`
TEXT_NORMAL=`tput sgr0`
STEP=0

# Checkout the original SVN repo
fnSVNCheckoutRepo() {
  svn checkout $REPO_URL $REPO_DIR/$REPO_NAME.svn
}

# Retrieve a list of SVN committers from the original SVN repo
fnSVNGetCommitters() {
  #svn log ^/ --xml $REPO_DIR/$REPO_NAME.svn | grep -P "^<author" | sort -u | perl -pe 's/<author>(.*?)<\/author>/$1 = /' > $REPO_DIR/authors-transform.txt
  svn log -q $REPO_DIR/$REPO_NAME.svn | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > $REPO_DIR/authors-transform.txt
}

# Clone the SVN repo using git-svn to a transitional Git SVN repo
fnGitSVNCloneRepo() {
  #git svn clone $REPO_URL -A $REPO_DIR/authors-transform.txt --stdlayout $REPO_DIR/$REPO_NAME.gitsvn --prefix=svn/ --no-metadata
  git svn clone $REPO_URL -A $REPO_DIR/authors-transform.txt --stdlayout $REPO_DIR/$REPO_NAME.gitsvn --prefix=svn/
}

# Convert svn:ignore properties to .gitignore in the transitional Git SVN repo
fnGitSVNConvertIgnore() {
  #cd $REPO_DIR/$REPO_NAME.gitsvn
  #git svn show-ignore > $REPO_DIR/$REPO_NAME.gitsvn/.gitignore
  cd $REPO_DIR/$REPO_NAME.svn
  svn propget -R svn:ignore | sed 's/ - /\//' > $REPO_DIR/$REPO_NAME.gitsvn/.gitignore
  cd $REPO_DIR/$REPO_NAME.gitsvn
  git add .gitignore
  git commit -m 'Convert svn:ignore properties to .gitignore.'
}

# Clone the transitional Git SVN repo to the final Git repo
fnGitCloneRepo() {
  git clone file://$REPO_DIR/$REPO_NAME.gitsvn $REPO_DIR/$REPO_NAME.git
}

# Cleanup tags and branches on the final Git repo
fnGitCleanupTagsBranches() {
  cd $REPO_DIR/$REPO_NAME.git
  git svn-abandon-fix-refs
  git svn-abandon-cleanup
}

# Remove git-svn-id messages on the final Git repo
fnGitRemoveSvnIdMessages() {
  cd $REPO_DIR/$REPO_NAME.git
  git filter-branch -f --msg-filter 'sed -e "/git-svn-id:/d"'
}

# Remove empty commit messages on the final Git repo
fnGitRemoveEmptyCommitMessages() {
  cd $REPO_DIR/$REPO_NAME.git
  git filter-branch -f --msg-filter '
  read msg
  if [ -n "$msg" ] ; then
      echo "$msg"
  else
      echo "<empty commit message>"
  fi'
}

# Collect garbage on the Git repos
fnGitCollectGarbageRepos() {
  cd $REPO_DIR/$REPO_NAME.gitsvn
  git gc
  cd $REPO_DIR/$REPO_NAME.git
  git gc
}


printf "\n"
echo "--------------------------------------------------------------------------------"
echo "SVN to Git migration script"
echo "--------------------------------------------------------------------------------"
printf "\n"
echo "Repository: $REPO_URL"
echo "Original SVN repo: $REPO_DIR/$REPO_NAME.svn"
echo "Transitional Git SVN repo: $REPO_DIR/$REPO_NAME.gitsvn"
echo "Final Git repo: $REPO_DIR/$REPO_NAME.git"
read -p "Press ${TEXT_BOLD}[ENTER]${TEXT_NORMAL} to continue..."

mkdir -p $REPO_ROOT
cd $REPO_ROOT

# Checkout the original SVN repo
STEP=$((STEP+1))
while true; do
  printf "\n$STEP) Checkout the original SVN repo?"
  printf " [${TEXT_BOLD}y${TEXT_NORMAL}]es, [${TEXT_BOLD}n${TEXT_NORMAL}]o (default: yes) "
  read yn
  case $yn in
    [Yy]*|"" ) fnSVNCheckoutRepo; break;;
    [Nn]* ) break;;
    * ) ;;
  esac
done

# Retrieve a list of SVN committers from the original SVN repo
STEP=$((STEP+1))
while true; do
  printf "\n$STEP) Retrieve a list of SVN committers from the original SVN repo?"
  printf " [${TEXT_BOLD}y${TEXT_NORMAL}]es, [${TEXT_BOLD}n${TEXT_NORMAL}]o (default: yes) "
  read yn
  case $yn in
    [Yy]*|"" ) fnSVNGetCommitters; break;;
    [Nn]* ) break;;
    * ) ;;
  esac
done

# Clone the SVN repo using git-svn to a transitional Git SVN repo
STEP=$((STEP+1))
while true; do
  printf "\n$STEP) Clone the SVN repo using git-svn to a transitional Git SVN repo?"
  printf " [${TEXT_BOLD}y${TEXT_NORMAL}]es, [${TEXT_BOLD}n${TEXT_NORMAL}]o (default: yes) "
  read yn
  case $yn in
    [Yy]*|"" ) fnGitSVNCloneRepo; break;;
    [Nn]* ) break;;
    * ) ;;
  esac
done

# Convert svn:ignore properties to .gitignore in the transitional Git SVN repo
STEP=$((STEP+1))
while true; do
  printf "\n$STEP) Convert svn:ignore properties to .gitignore in the transitional Git SVN repo?"
  printf " [${TEXT_BOLD}y${TEXT_NORMAL}]es, [${TEXT_BOLD}n${TEXT_NORMAL}]o (default: yes) "
  read yn
  case $yn in
    [Yy]*|"" ) fnGitSVNConvertIgnore; break;;
    [Nn]* ) break;;
    * ) ;;
  esac
done

# Clone the transitional Git SVN repo to the final Git repo
STEP=$((STEP+1))
while true; do
  printf "\n$STEP) Clone the transitional Git SVN repo to the final Git repo?"
  printf " [${TEXT_BOLD}y${TEXT_NORMAL}]es, [${TEXT_BOLD}n${TEXT_NORMAL}]o (default: yes) "
  read yn
  case $yn in
    [Yy]*|"" ) fnGitCloneRepo; break;;
    [Nn]* ) break;;
    * ) ;;
  esac
done

# Cleanup tags and branches on the final Git repo
STEP=$((STEP+1))
while true; do
  printf "\n$STEP) Cleanup tags and branches on the final Git repo?"
  printf " [${TEXT_BOLD}y${TEXT_NORMAL}]es, [${TEXT_BOLD}n${TEXT_NORMAL}]o (default: yes) "
  read yn
  case $yn in
    [Yy]*|"" ) fnGitCleanupTagsBranches; break;;
    [Nn]* ) break;;
    * ) ;;
  esac
done

# Remove git-svn-id messages on the final Git repo
STEP=$((STEP+1))
while true; do
  printf "\n$STEP) Remove git-svn-id messages on the final Git repo?"
  printf " [${TEXT_BOLD}y${TEXT_NORMAL}]es, [${TEXT_BOLD}n${TEXT_NORMAL}]o (default: yes) "
  read yn
  case $yn in
    [Yy]*|"" ) fnGitRemoveSvnIdMessages; break;;
    [Nn]* ) break;;
    * ) ;;
  esac
done

# Remove empty commit messages on the final Git repo
STEP=$((STEP+1))
while true; do
  printf "\n$STEP) Remove empty commit messages on the final Git repo?"
  printf " [${TEXT_BOLD}y${TEXT_NORMAL}]es, [${TEXT_BOLD}n${TEXT_NORMAL}]o (default: yes) "
  read yn
  case $yn in
    [Yy]*|"" ) fnGitRemoveEmptyCommitMessages; break;;
    [Nn]* ) break;;
    * ) ;;
  esac
done

# Collect garbage on the Git repos
STEP=$((STEP+1))
while true; do
  printf "\n$STEP) Collect garbage on the Git repos?"
  printf " [${TEXT_BOLD}y${TEXT_NORMAL}]es, [${TEXT_BOLD}n${TEXT_NORMAL}]o (default: yes) "
  read yn
  case $yn in
    [Yy]*|"" ) fnGitCollectGarbageRepos; break;;
    [Nn]* ) break;;
    * ) ;;
  esac
done

printf "\n"
echo "--------------------------------------------------------------------------------"
echo "Done migrating!"
echo "--------------------------------------------------------------------------------"
printf "\n"
echo "Repository: $REPO_URL"
echo "Original SVN repo: $REPO_DIR/$REPO_NAME.svn"
echo "Transitional Git SVN repo: $REPO_DIR/$REPO_NAME.gitsvn"
echo "Final Git repo: $REPO_DIR/$REPO_NAME.git"
printf "\n"
du $REPO_DIR/$REPO_NAME.svn $REPO_DIR/$REPO_NAME.gitsvn $REPO_DIR/$REPO_NAME.git -hsc | tee $REPO_DIR/du.log
read -p "Press ${TEXT_BOLD}[ENTER]${TEXT_NORMAL} to continue..."

