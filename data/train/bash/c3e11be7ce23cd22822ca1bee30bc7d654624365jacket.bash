#!/usr/bin/env bash
# load our default flannel, its cold in bash
# - cleans breadcrumbs out of var from last run
# - load's default home config if it's there
# - load's any specified named home default config on top of that
# - load's any local plaid_patces
jacket() { 
  _flannel_core_clear_reverse_dependencies

  _flannel_core_clear_spool

  # load home default config if exists
  [[ -f ~/.flannelrc ]] && _flannel_core_load_module_config < ~/.flannelrc

  # if we passed a named profile to load
  if [[ -n "$1" ]]; then
    [[ -f ~/."$1".flannelrc ]] && _flannel_core_load_module_config < ~/."$1".flannelrc
  fi

  # load patches
  [[ -f ./.plaid_patch ]] && _flannel_core_load_module_config < ./.plaid_patch
}
