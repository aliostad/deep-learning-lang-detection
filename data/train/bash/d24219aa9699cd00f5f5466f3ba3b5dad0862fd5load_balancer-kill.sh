#!/bin/bash
#
# Usage:
#  $0 load_balancer_id
#
set -e
set -o pipefail
set -u

## shell params

load_balancer_id="${1}"
: "${load_balancer_id:?"should not be empty"}"

## main

while read network_vif_id; do
  ${BASH_SOURCE[0]%/*}/load_balancer-unregister-vif.sh "${load_balancer_id}" "${network_vif_id}" >/dev/null
done < <(mussel load_balancer show "${load_balancer_id}" | egrep network_vif_id | awk '{print $3}')

mussel load_balancer destroy "${load_balancer_id}" >/dev/null
echo "${load_balancer_id} is shuttingdown..." >&2

##

. ${BASH_SOURCE[0]%/*}/retry.sh

retry_until [[ '"$(mussel load_balancer show "${load_balancer_id}" | egrep -w "^:state: terminated")"' ]]
echo load_balancer_id="${load_balancer_id}"
