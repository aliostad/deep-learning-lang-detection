#!/bin/sh

base=$(dirname $0)/..
. $base/test/test_helper.sh

__need_sleep=
process() {
  # ensure that the time stamps in run IDs are different
  [ -z "$__need_sleep" ] || sleep 1
  pkg="$1"
  dependencies="$2"
  DEBCI_FAKE_DEPS="$dependencies" \
    debci test --quiet "$pkg"
    debci update --quiet
  __need_sleep=1
}

test_package_that_never_passed_a_test_cant_blame() {
  result_fail process foobar 'foo 1.2.3'
  result_fail process foobar 'foo 1.2.4'
  assertEquals '' "$(debci status --field blame foobar)"
}

test_failing_test_blames_dependencies() {
  result_pass process foobar 'foo 1.2.3|bar 2.3.4'
  result_fail process foobar 'foo 1.3.1|bar 2.3.4'
  blame="$(debci status --field blame foobar)"
  assertEquals 'foo	1.3.1' "$blame"
}

test_updated_dependency_of_already_failing_package_is_not_blamed() {
  result_pass process foobar 'foo 1.2.3|bar 4.5.6'
  result_fail process foobar 'foo 2.0.0|bar 4.5.6'
  result_fail process foobar 'foo 2.0.0|bar 4.5.7'
  assertEquals 'foo	2.0.0' "$(debci status --field blame foobar)"
}

test_new_dependency_of_already_failing_package_is_not_blamed() {
  result_pass process foobar 'foo 1.2.3'
  result_fail process foobar 'foo 1.2.4'
  result_fail process foobar 'foo 1.2.4|bar 4.5.6'
  assertEquals 'foo	1.2.4' "$(debci status --field blame foobar)"
}

test_passing_the_test_resets_the_blame() {
  result_pass process foobar 'foo 1.2.3'
  result_fail process foobar 'foo 1.2.4'
  result_pass process foobar 'foo 1.2.5'
  assertEquals '' "$(debci status --field blame foobar)"
}

test_blame_updated_dependency() {
  result_pass process foobar 'foo 1.2.3'
  result_fail process foobar 'foo 1.2.4'
  result_fail process foobar 'foo 1.2.5'
  assertEquals 'foo	1.2.5' "$(debci status --field blame foobar)"
}

test_updated_dependencies_dont_get_blamed_when_package_is_also_updated() {
  result_pass process foobar 'foobar 1.0|foo 1.0|bar 1.0'
  result_fail process foobar 'foobar 1.1|foo 1.1|bar 1.1'
  assertEquals '' "$(debci status --field blame foobar)"
}

test_package_is_not_blamed_for_its_own_failure() {
  result_pass process foobar 'foobar 1.0|foo 1.0|bar 1.0'
  result_fail process foobar 'foobar 1.1|foo 1.0|bar 1.0'
  assertEquals '' "$(debci status --field blame foobar)"
}

. shunit2
