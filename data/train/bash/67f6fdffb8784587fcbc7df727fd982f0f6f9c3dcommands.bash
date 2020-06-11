# some common functions

# Remove a package; this will remove it from all repositories it can
# find it in, for all the specified architectures.
#
# remove_package  name arch1 [arch2...]
remove_package() {
  local pkg="$1"; shift
  local from_arch=("$@")

  for repo in "${repo_list[@]}"; do
    if [[ $repo =~ ^(.*):(.*)$ ]]; then
      # a repo that exists only for a specific architecture
      local repo_arch="${BASH_REMATCH[1]}"
      local repo_repo="${BASH_REMATCH[2]}"
      if contains_or_ALL "$repo_arch" "${from_arch[@]}"; then
        remove_package_from "$pkg" "$repo_repo" "$repo_arch"
      fi
    else
      # this repo is supposed to exist in all architectures
      if cd "${repo_base}/${repo}/os"; then
        for i in *; do
          if contains_or_ALL "$i" "${from_arch[@]}"; then
            remove_package_from "$pkg" "$repo" "$i"
          fi
        done
      fi
    fi
  done
}

# The removal implementation taking exactl
# 1 package name and
# 1 repository name
# 1 architecture name
remove_package_from_or_all() {
  local pkg="$1"
  local repo="$2"
  local arch="$3"
  if [[ $arch == ALL ]]; then
    local repo_list_backup=("${repo_list[@]}")
    repo_list=("$repo")
    remove_package "$pkg" ALL
    repo_list=("${repo_list_backup[@]}")
  else
    remove_package_from "$@"
  fi
}

# The removal implementation taking exactly
# 1 package name and
# 1 repository name
# 1 architecture name
remove_package_from() {
  local pkg="$1"
  local repo="$2"
  local arch="$3"

  if ! check_access "$repo" "$arch" "$pkg"; then
    wrn "skipping repository %s/%s for package %s" "$repo" "$arch" "$pkg"
    return 1
  fi

  if ! cd "${repo_base}/${repo}/os/${arch}"; then
    err "failed to find repository %s/%s" "$repo" "$arch"
    return 1
  fi

  pushopt -s extglob nullglob
  log "removing package %s from %s/%s" "$pkg" "$repo" "$arch"
  if repo-remove "${repo}.db.tar.gz" "${pkg}" 2>/dev/null; then
    if ! rm -v "${pkg}"${APLC_PKG_REST_EXTGLOB} 2>/dev/null; then
      log "old files for package %s from %s/%s not found" "$pkg" "$repo" "$arch"
    fi
    run_hook remove_package "$pkg" "$repo" "$arch"
  else
    wrn "failed to remove package %s from %s/%s" "$pkg" "$repo" "$arch"
  fi
  popopt extglob nullglob
}

# Run a repo-report for an architecture
repo_report() {
  local arch="$1"
  log 'repo report of %s' "$arch"
  run_local_command repo_report "$arch"
}
