#!/usr/bin/env bash
# =========================================================================== #
# File: ~/.bash/plugins.sh
# Author: Jacky Alcine <yo@jacky.wtf>
# Description: Entry point for all plugins.
# =========================================================================== #

function load_plugin() {
  [ -x $1 ] && source $1;
}

function load_default_plugins() {
  local _paths=$(find $HOME/.bash/plugins.d -type l -name "[0-8]*_*.sh" | sort);

  for path in ${_paths}; do
    load_plugin ${path};
  done
}

function load_custom_plugins() {
  local _paths=$(find $HOME/.bash/plugins.d -type f -name "9*_*.sh" | sort);

  for path in ${_paths}; do
    load_plugin ${path};
  done
}

load_default_plugins;
load_custom_plugins;
