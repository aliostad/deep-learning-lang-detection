#!/bin/bash
#
# Author: Jan Friesse <jfriesse@redhat.com>
#

test_description="Test that full /dev/shm doesn't cause problem but clients are not accepted"

. inc/common.sh
. inc/cpg-load.sh

nospace_image_file_size=100000
nospace_image_mount_point="/dev/shm"

. inc/nospace.sh


configure_corosync "$nodes_ip"

nospace_init "$nodes_ip"

start_corosync "$nodes_ip"

cpg_load_prepare "$nodes_ip"
cpg_load_one_shot "$nodes_ip"

nospace_fill "$nodes_ip"

# Cpg_load should not start
cpg_load_one_shot "$nodes_ip" && exit 1 || true

# After fill file removal, everything should work again
nospace_flush "$nodes_ip"
cpg_load_one_shot "$nodes_ip"

stop_corosync "$nodes_ip"

exit 0
