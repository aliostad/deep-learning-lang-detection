function repo_checkout_local() {
  if [[ ! -d .repo ]]; then
    echo "ERROR: $PWD is not managed by repo"
    return 1
  fi

  if [[ -z "$1" ]]; then
    echo "ERROR: specify a branch name as an argument"
    return 1
  fi

  for dir in */; do
    cd $dir
    git checkout $1
    cd -
  done
}

function repo_push_local_branch_to_asynchrony() {
  if [[ ! -d .repo ]]; then
    echo "ERROR: $PWD is not managed by repo"
    return 1
  fi

  for dir in */; do
    cd $dir
    git push -u asynchrony HEAD
    cd -
  done
}

function check_repo_installed() {
  if [[ -z `which repo > /dev/null 2>&1` ]]; then
    # repo is not installed
    case `uname -s` in
      Darwin)
        brew install repo
        ;;
      *)
        echo "ERROR: repo is not install or on the path"
        echo "see http://source.android.com/source/downloading.html#installing-repo"
        return 1
        ;;
    esac
  fi
}

# Example usage:
# repo_bootstrap secure_share_workspace https://git.asynchrony.com/proj-1016/secure_share_repo
function repo_bootstrap() {
  check_repo_installed

  if [[ -z "$1" ]]; then
    echo "ERROR: specify a workspace directory"
    return 1
  fi

  if [[ -z "$2" ]]; then
    echo "ERROR: specify a repo manifest url"
    return 1
  fi

  mkdir -p "$1"
  cd "$1"
  repo init -u "$2"
  repo sync
}
