# Helper for loading test fixtures.
fixtures () {
  FIXTURE_ROOT="$BATS_TEST_DIRNAME/fixtures/$1"
  RELATIVE_FIXTURE_ROOT="$(bats_trim_filename "$FIXTURE_ROOT")"
}

# Create a temporary directory and set path of executable to test.
setup () {
  export TMP="$(mktemp --directory --tmpdir="$BATS_TMPDIR" "bats-expand-template-$BATS_TEST_NAME.XXXXXXXXXX")"
  export EXEC="$BATS_TEST_DIRNAME/../src/bin/varrick"
}

# Delete the temporary directory.
teardown () {
  [ -e "$TMP" ] && rm -r "$TMP"
}

# Load a library from the `${BATS_TEST_DIRNAME}/test_helper' directory.
#
# Globals:
#   none
# Arguments:
#   $1 - name of library to load
# Returns:
#   0 - on success
#   1 - otherwise
load_lib() {
  local name="$1"
  load "test_helper/${name}/load"
}

load_lib bats-core
load_lib bats-assert
load_lib bats-file
BATSLIB_FILE_PREFIX="$TMP"
