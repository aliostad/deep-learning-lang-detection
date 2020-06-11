#!/bin/bash
set -e -u

# make sure we're always running from the same directory, regardless of what the 
# current working directory was when this script was run
MY_DIR="$( cd "$( dirname "$0" )" && pwd )"
REPOS=(
  'pretend_web_app'
	'pretend_catalog_service'
	'pretend_pricing_service'
	'pretend_deals_service'
	)

function prep_if_needed {
	local repo_name=$1
	local repo_dir="$MY_DIR/$repo_name"
	local repo_url="git@github.com:moredip/$repo_name.git"
	#local repo_url="git@github.com:ThoughtWorks-AELab/$repo_name.git"

	if [ ! -d $repo_dir ]
	then
	  echo "Looks like you don't have the $repo_name repo. Cloning it for you now..."
	  git clone $repo_url $repo_dir

		cd $repo_dir
		if [ -x "./tooling/devprep" ]
		then
		  ./tooling/devprep
    else
			echo "!!! NO DEVPREP FOR $repo_name"
		fi
  fi
}

function pull {
	local repo_name=$1
	local repo_dir="$MY_DIR/$repo_name"
	echo "pulling $repo_name..."
	(cd $repo_dir && git pull)
}

function run {
	local repo_name=$1
	local repo_dir="$MY_DIR/$repo_name"
	(cd $repo_dir && bundle exec rake server)
}

function prep_all {
  for repo in "${REPOS[@]}"
  do
    prep_if_needed $repo
  done
}

function pull_all {
  for repo in "${REPOS[@]}"
  do
    pull $repo
  done
}

function run_all {
  for repo in "${REPOS[@]}"
	do
	  run $repo &
	done

	wait
}


valid_commands="\n\tprep\n\tpull\n\trun"
case "${1:-}" in 

'')
  echo -e "Valid commands are:$valid_commands"
  ;;
prep)
	prep_all
  ;;
pull)
	prep_all
  pull_all
  ;;
run)
	prep_all
  run_all
	;;
*)
  echo -e "Unrecognized command. Valid commands are:$valid_commands"
  ;;
esac
