#!/bin/bash -eu
thisDir="$(dirname $0)"
thisDir="$(readlink -f "$thisDir")"
path_config_sh="$thisDir/../path_config.sh"

repo="$(readlink -f "$thisDir"/../repo)"

rm -f "$path_config_sh"
echo "REPO_DIR=$repo" >> "$path_config_sh"

function extract_project() {
  project_name="$1"
  project_var="$2"
  tar xf "$repo/$project_name"-1.0-SNAPSHOT.tar -C "$repo/"
  echo "$project_var=$repo/$project_name" >> "$path_config_sh"
}

extract_project tester TESTER_DIR

# examples for unzip and tar with specified outdir and overwrite option

# unzip -oq "$repo"/hsqldb/hsqldb-2.3.0.zip -d "$repo"

# tar xf "$repo"/hama/hama-0.6.1.tar.gz -C "$repo"

echo "installation done"

