#!/bin/zsh
zmodload zsh/mapfile

current_folder=`dirname $0:A`
repo_file=$current_folder/repos
repo_list=( "${(f)mapfile[$repo_file]}" )
workspace_dir=$current_folder/workspace

function doClean() {
  echo "Removing ${workspace_dir}"
  rm -rf $workspace_dir
}

function doClone() {
  mkdir -p $workspace_dir

  cd $workspace_dir
    for repo in $repo_list; do
      git clone git@github.com:${repo}.git
    done
  cd -
}

function doTag() {
  for repo in $repo_list; do
    repo_dir=`echo "$repo"|sed "s/.*\///"`

    cd $workspace_dir/$repo_dir
      gr tag add venus
    cd -
  done
}

function doNpmInstall() {
  gr -t venus npm install --registry=http://registry.npmjs.org
}

function doNpmLink() {
  for repo in $repo_list; do
    repo_dir=`echo "$repo"|sed "s/.*\///"`
    local_repo_dir=$workspace_dir/$repo_dir
    module_dir=./node_modules/$repo_dir

    cd $local_repo_dir
      for inner_repo in $repo_list; do
        inner_repo_dir=`echo "$inner_repo"|sed "s/.*\///"`
        local_inner_repo_dir=$workspace_dir/$inner_repo_dir
        module_dir=./node_modules/$inner_repo_dir

        if [[ $inner_repo_dir != $repo_dir ]]; then
          rm -rf $module_dir
          ln -s $local_inner_repo_dir $module_dir
        fi
      done
    cd -
  done
}

function doAll() {
  reply=n

  vared -p "This will delete your local clones. You may lose work. Are you sure? (y/n) " reply

  if [[ $reply =~ ^[Yy]$ ]]; then
    doClean
    doClone
    doTag
    doNpmInstall
    doNpmLink
  fi
}

function init() {
  if [[ $1 == "install" ]]; then
    doNpmInstall
  elif [[ $1 == "link" ]]; then
    doNpmLink
  else
    doAll
  fi
}

init $@
