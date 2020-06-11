# set up two vm's intended to be a nova controller and a nova compute
# node.  take a snapshot of the clients and foreman right before
# they register so we can easily revert, retry, etc.

MCS_SCRIPTS_DIR=${MCS_SCRIPTS_DIR:=/mnt/vm-share/mcs}
export INITIMAGE=${INITIMAGE:=rhel6rdo}
FOREMAN_NODE=${FOREMAN_NODE:=s14fore1}
VMSET_CHUNK=${VMSET_CHUNK:=s14ha2}

SKIPSNAP=true SKIP_FOREMAN_CLIENT_REGISTRATION=true \
 $MCS_SCRIPTS_DIR/client-vms/new-foreman-clients.bash 2

# we've got two clean hosts, set the openstack-related IP's

vftool.bash configure_nic ${VMSET_CHUNK}1 static eth2 192.168.200.10 255.255.255.0
vftool.bash configure_nic ${VMSET_CHUNK}1 static eth3 192.168.201.10 255.255.255.0

vftool.bash configure_nic ${VMSET_CHUNK}2 static eth2 192.168.200.20 255.255.255.0
vftool.bash configure_nic ${VMSET_CHUNK}2 static eth3 192.168.201.20 255.255.255.0

SNAPNAME=$SNAPNAME bash -x vftool.bash reboot_snap_take ${VMSET_CHUNK}1 ${VMSET_CHUNK}2 $FOREMAN_NODE

VMSET="${VMSET_CHUNK}1 ${VMSET_CHUNK}2" bash -x $MCS_SCRIPTS_DIR/client-vms/register-clients.bash

# all right, you should be able to use ${VMSET_CHUNK}1 as your controller,
# and  ${VMSET_CHUNK}2 as your compute node.  (you'll need to associate them
# with the relevant host groups in the foreman UI)
