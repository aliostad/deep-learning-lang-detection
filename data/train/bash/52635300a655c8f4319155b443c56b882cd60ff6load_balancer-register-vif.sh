#!/bin/bash
#
# Usage:
#  $0 load_balancer_id
#
set -e
set -o pipefail
#set -u

## shell params

load_balancer_id="${1}"
: "${load_balancer_id:?"should not be empty"}"
shift
vifs="${@:-""}"
: "${vifs:?"should not be empty"}"

## register vifs to the load_balancer

network_vif_id=
while [[ "${1:-""}" ]]; do
  network_vif_id="${1}"
  echo "registering ${network_vif_id} to ${load_balancer_id}..." >&2
  mussel load_balancer register "${load_balancer_id}" \
   --vifs "${network_vif_id}" >/dev/null
  shift
done

echo load_balancer_id="${load_balancer_id}"
