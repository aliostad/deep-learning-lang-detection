main() {
  save=0
  save_dev=0
  save_opt=0

  i=0
  while [ $i -lt $# ]; do
    o="$1"; shift
    case "$o" in
      -S|--save) save=1 ;;
      -D|--save-dev) save_dev=1 ;;
      -O|--save-optional) save_opt=1 ;;
      -*) log error "Unknown argument $o" && return 1;;
      *) set -- "$@" "$o"
    esac
    let i=i+1
  done

  [ -z "$1" ] && return 1

  for package in "$@"; do
    pkg=""
    uninstall "$pkg"
    [ $? -ne 0 ]  && return 1
    [ $save -eq 1 ] && turtle config del "dependancies.$pkg"
    [ $save_dev -eq 1 ] && turtle config del "devDependancies.$pkg"
    [ $save_opt -eq 1 ] && turtle config del "optionalDependancies.$pkg"
  done
}

uninstall() {
  pkg="$1"; shift
  if [ -d "deps/$pkg" ]; then
    rm -rf "deps/$pkg"
  fi
}

usage() {
  echo
  echo "  uninstall packages or remove dependancies"
  echo
  echo "  Usage: "
  echo "    turtle-uninstall <github-user>/<github-repo>"
  echo "    turtle-uninstall "
  echo
  echo "  -h, --help           show help for this binary"
  echo "  -S, --save           remove packages from dependancies"
  echo "  -D, --save-dev       remove packages from devDependancies"
  echo "  -O, --save-optional  remove packages from optionalDependancies"
  echo
}
