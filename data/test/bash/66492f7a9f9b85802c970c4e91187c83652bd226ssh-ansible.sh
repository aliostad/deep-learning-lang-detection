#!/bin/bash
# This script is executed by the remote.sh
set -e

# configuration options
# =====================
#
# PROJECT_FOLDER (default: "$(pwd)")
#   Absolute path of the Project (containing the Vagrantfile)
# VAGRANT_ANSIBLE_MACHINE (default: "default")
#   Vagrant name of the machine with Ansible
# ANSIBLE_ENV
#   Environment variables for the ansible invoke script
#   ENV_NAME=env_value NAME2=Value2
# VAGRANT_SSH_ARGS
#   Extra SSH arguments for vagrant
# VAGRANT_PROJECT_MOUNT (default: "/vagrant")
#   Where is the project mounted in the Vagrant guest
# VAGRANT_ANSIBLE_REMOTE (default: "vagrant_ansible_remote")
#   Relative path of vagrant-ansible-remote to the project
# VAGRANT_ANSIBLE_INVOKE_PREFIX (default: "")
#   Prefix command for the invokation script
# VAGRANT_ANSIBLE_INVOKE_SCRIPT (default: "remote.sh")
#   Path of the invokated script relative to vagrant-ansible-remote

# --- option defaults ---
PROJECT_FOLDER=${PROJECT_FOLDER:=$(pwd)}
VAGRANT_ANSIBLE_MACHINE=${VAGRANT_ANSIBLE_MACHINE:=default}
VAGRANT_PROJECT_MOUNT=${VAGRANT_PROJECT_MOUNT:=/vagrant}
VAGRANT_ANSIBLE_REMOTE=${VAGRANT_ANSIBLE_REMOTE:=vagrant_ansible_remote}
VAGRANT_ANSIBLE_INVOKE_SCRIPT=${VAGRANT_ANSIBLE_INVOKE_SCRIPT:=remote.sh}

# --- build the command ---
COMMAND="/bin/bash $VAGRANT_PROJECT_MOUNT/$VAGRANT_ANSIBLE_INVOKE_SCRIPT $ANSIBLE_RUN_ARGS"
COMMAND="VAGRANT_INVOKED=true $COMMAND"
COMMAND="VAGRANT_ANSIBLE_REMOTE=$VAGRANT_ANSIBLE_REMOTE $COMMAND"
COMMAND="PROJECT_FOLDER=$VAGRANT_PROJECT_MOUNT $COMMAND"
if [[ ! -z $ANSIBLE_ENV ]]; then
  COMMAND="$ANSIBLE_ENV $COMMAND"
fi
if [ ! -z $VAGRANT_ANSIBLE_INVOKE_PREFIX ]; then
  COMMAND="$VAGRANT_ANSIBLE_INVOKE_PREFIX $COMMAND"
fi
if [ ! -z $VAGRANT_SSH_ARGS ]; then
  VAGRANT_SSH_ARGS=" -- $VAGRANT_SSH_ARGS"
fi

#  --- vagrant requires to be in the folder ---
pushd $PROJECT_FOLDER

# --- check that all vagrant machines are up ---
vagrant status --machine-readable | while IFS=, read time name kind state; do
  if [ "$kind" != "state" ]; then
    continue
  fi
  if [ "$state" != "running" ]; then
    vagrant up
    break
  fi
done

# --- run the command ---
vagrant ssh $VAGRANT_ANSIBLE_MACHINE --command "$COMMAND"$VAGRANT_SSH_ARGS 2>/dev/null

popd
