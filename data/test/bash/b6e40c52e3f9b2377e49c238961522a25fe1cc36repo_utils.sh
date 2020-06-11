#Addons to google repo tool
#tweakenv/git/GitAliases.ini should be activated (see readme.md) !

function repo_help() {
  doc="
Read the following docs :
  repo help
  repo help manifest

Show all repositories status
  repo status

Show outgoing commits
  repo_outgoing

Show incoming commits
  repo_incoming

Show the current google repo top folder :
  repo_find_toprepo_folder
"
  echo $doc
}

function repo_find_toprepo_folder() {
  local startfolder=$(pwd)

  local currentfolder="$startfolder"

  if [ -d .repo ]; then
    echo $currentfolder
    cd $startfolder
    return
  fi

  while [ $currentfolder != "/" ]; do
    cd ..
    currentfolder=$(pwd)
    if [ -d .repo ]; then
      echo $currentfolder
      cd $startfolder
      return
    fi
  done

  echo "This is not a google repo subfolder..."
  cd $startfolder
  return
}

function repo_list_present_repositories() {
  local startfolder=$(pwd)

  cd $(repo_find_toprepo_folder)

  for folder in $(find . -type d -maxdepth 3); do
    if [[ ${folder:0:7} != "./.repo" ]]; then # skip .repo/ and its subfolders...
      gitdir=$folder/.git
      if [ -d $gitdir ]; then
        echo $folder
      fi
    fi
  done

  cd $startfolder
  return
}

function repo_pullrebase_fromcurrentbranches() {
  local startfolder=$(pwd)
  topfolder=$(repo_find_toprepo_folder)
  echo "Going to $topfolder"
  cd $topfolder

  for folder in $(repo_list_present_repositories); do
    echo "git pull --rebase in folder :  $folder"
    cd $folder
    git pull --rebase
    cd $topfolder
  done

  cd $startfolder
  return
}

function repo_outgoing() {
  repo forall -c git repo-outgoing
}

function repo_incoming() {
  repo forall -c git repo-incoming
}



confirm () {
    echo "Are you sure [y/N] ?"
    read response
    case $response in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

function repo_push_set_upstream() {
  echo "This script will push all repositories to ivs-gitlab, in their current branch"
  echo "If needed, new branches will be pushed to the server (even with no commit)"
  confirm && repo forall -c git repo-push-current-branch-set-upstream
}
