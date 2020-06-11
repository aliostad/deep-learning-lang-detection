#!/usr/bin/env bash

. lib/functions.sh
. lib/silence_warnings.sh
. lib/silence_praise.sh

TRUE=0
FALSE=1

test_flunked=$FALSE
function flunk() {
  test_flunked=$TRUE
}

function expect_failure() {
  if [ $test_flunked -eq $TRUE ] ; then
    test_flunked=$FALSE
  else
    test_flunked=$TRUE
  fi
}

function invoke_should_pass_CI_ROOT_variable() {
  invoke "01_check_ci_root_var"
}

function invoke_should_not_pass_functions() {
  invoke "01_check_has_no_functions"
}

function invoke_should_fail_if_missing_script_and_not_in_acceptable_misses() {
  invoke "XX_file_does_not_exist"
  expect_failure
}

function invoke_should_not_fail_if_missing_script_in_acceptable_misses() {
  ocst=( ${can_skip_tasks[@]} )
  can_skip_tasks=( XX_file_does_not_exist_either )
  invoke "XX_file_does_not_exist_either"
  can_skip_tasks=( ${ocst[@]} )
}

function invoke_a_failing_script_should_fail() {
  invoke "01_will_fail"
  expect_failure
}

function invoke_a_failing_script_will_pass_if_whitelisted() {
  ocft=( ${can_skip_tasks[@]} )
  can_fail_tasks=( 01_will_fail )
  invoke "01_will_fail"
  can_fail_tasks=( ${ocft[@]} )
}

# GO TO THE DIRECTORY WHERE OUR MOCK ci DIRECTORY LIVES
cd ci/mocks

callbacks=( \
  invoke_should_pass_CI_ROOT_variable \
  invoke_should_not_pass_functions \
  invoke_should_fail_if_missing_script_and_not_in_acceptable_misses \
  invoke_should_not_fail_if_missing_script_in_acceptable_misses \
  invoke_a_failing_script_should_fail \
  invoke_a_failing_script_will_pass_if_whitelisted \
)

failure_memo=( )

index=0
while [ $index -lt ${#callbacks[@]} ] ; do
  test_flunked=$FALSE
  ${callbacks[$index]}
  if [ $test_flunked -eq $TRUE ] ; then
    failure_memo[${#failure_memo[*]}]="${callbacks[$index]}"
  fi
  let index=index+1
done

if [ ${#failure_memo[@]} -gt 0 ] ; then
  echo "FAILED SUBTESTS: ${failure_memo[@]}"
  false
else
  true
fi
