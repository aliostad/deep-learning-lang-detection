
# Uninstall Functions
# file: ./lib/_uninstall.sh
################################################################################
function _uninstall {
  local repo="${config[repo]}"
  local lib="${config[${config[method]}]}"
  local bin="${config["${config[method]}_bin"]}"
  if [ "${config[method]}" != "global" ]; then
    lib="${config[working]}/$lib"
  fi
  _message "Removing $repo:"
  if test -d $lib/$repo; then
    _configure "$lib/$repo/package.conf"
    _message " -> $lib/$repo"
    rm -rf $lib/$repo
  else
    repo="$(echo $repo | awk -F'/' '{ print $2 }' | xargs)"
    if test -d $lib/$repo; then
      _configure "$lib/$repo/package.conf"
      _message " -> $lib/$repo"
      rm -rf $lib/$repo
    else
      _echoerr "Couldn't find anything to remove."
      exit 1
    fi
  fi
  if test "${config[bin]}"; then
    _message " -> $bin/${config[bin]}"
    rm -f "$bin/${config[bin]}"
  fi
}
