#!/usr/bin/env bash
# =========================================================================== #
# File: ~/.bash/aliases.sh
# Author: Jacky Alcine <yo@jacky.wtf>
# Description: Entry point for all aliases.
# =========================================================================== #

load_alias() {
  [[ -x $1 ]] && source $1;
}

load_default_aliases() {
  local _paths=$(find $HOME/.bash/aliases.d -type l -name "[0-8]*_*.sh" | sort);

  for path in ${_paths}; do
    load_alias ${path};
  done
}

load_custom_aliases() {
  local _paths=$(find $HOME/.bash/aliases.d -type f -name "9*_*.sh" | sort);

  for path in ${_paths}; do
    load_alias ${path};
  done
}

load_custom_aliases;
load_default_aliases;
