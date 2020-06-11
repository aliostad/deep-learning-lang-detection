source ./test/support/assertions.sh

source ./lib/_fetch.sh

# _fetch.sh dependancies
source ./lib/_config.sh
source ./lib/_utils.sh

function cleanup { rm -rf /tmp/.odbpm.*; }
function before  { cleanup; }
function after   { cleanup; }

function run_tests {
  config[quiet]=true

  assert "_fetch_mktmp" "_fetch_mktmp: exists"
  assert_dir "/tmp/.odbpm.*" "_fetch_mktmp: create temp dir"

  _fetch_mktmp
  assert_grep "echo ${config[tmp]}" "/tmp/.odbpm." "_fetch_mktmp: set config[tmp]"

  # without version
  config[repo]="jmervine/odbpm-test"
  _fetch_repo
  assert_file "/tmp/.odbpm.*/master.zip" "_fetch_mktmp: fetch repo"
  assert_file "/tmp/.odbpm.*/odbpm-test/test.sh" "_fetch_mktmp: extract repo"

  # cleanup
  _fetch_cleanup
  refute_file "/tmp/.odbpm.*/master.zip" "_fetch_cleanup: fetched repo"
  refute_file "/tmp/.odbpm.*/odbpm-test/test.sh" "_fetch_cleanup: extracted repo"

  # with version
  config[repo]="jmervine/odbpm-test#0.0.1"
  _fetch_repo
  assert_file "/tmp/.odbpm.*/0.0.1.zip" "_fetch_repo: fetch repo with version"
  assert_file "/tmp/.odbpm.*/odbpm-test/test.sh" "_fetch_repo: extract repo with version"
  assert_grep "cat /tmp/.odbpm.*/odbpm-test/test.sh" "branch" "_fetch_repo: fetch correct version"

  # bad repo
  config[repo]="bad/repo"
  cleanup
  refute "_fetch_repo" "_fetch_repo: fail on bad repo"

  cleanup
  assert_stderr "_fetch_repo" "_fetch_repo: fail on bad repo"
}
# vim: ft=sh:

