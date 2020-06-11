#!/bin/bash

export APPS_SAVE_FILE='./apps_installed/save_apps.sh'
export BASH_SAVE_FILE='./bash_configuration/save_bash_configuration.sh'
export GIT_SAVE_FILE='./git_configuration/save_git_configuration.sh'

chmod 777 $APPS_SAVE_FILE
chmod 777 $BASH_SAVE_FILE
chmod 777 $GIT_SAVE_FILE

echo
echo '--- BREW and GEMS ---'
cd apps_installed
./save_apps.sh
cd ..

echo
echo '--- BASH CONFIGURATION ---'
cd bash_configuration
./save_bash_configuration.sh
cd ..

echo
echo '--- GIT CONFIGURATION ---'
cd git_configuration
./save_git_configuration.sh
cd ..

echo
echo 