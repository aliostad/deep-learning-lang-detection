#!/bin/bash
#
# requires:
#   bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## public functions

function test_load_hypervisor_driver_no_opts() {
  load_hypervisor_driver >/dev/null 2>&1
  assertNotEquals $? 0
}

function test_load_hypervisor_driver_kvm() {
  load_hypervisor_driver kvm >/dev/null
  assertEquals $? 0
}

function test_load_hypervisor_driver_unknown() {
  load_hypervisor_driver unknown >/dev/null 2>&1
  assertNotEquals $? 0
}


## shunit2

. ${shunit2_file}
