#!/bin/bash

create_proxy_protocol_policy() {
  local load_balancer_name=$1

  aws elb create-load-balancer-policy \
    --load-balancer-name "${load_balancer_name}" \
    --policy-name "${load_balancer_name}-ProxyProtocol-policy" \
    --policy-type-name ProxyProtocolPolicyType \
    --policy-attributes AttributeName=ProxyProtocol,AttributeValue=true \
  || exit $?
}

set_proxy_protocol_policy() {
  local load_balancer_name=$1

  aws elb set-load-balancer-policies-for-backend-server \
    --load-balancer-name "${load_balancer_name}" \
    --instance-port 80 \
    --policy-names "${load_balancer_name}-ProxyProtocol-policy" \
  || exit $?
}

describe_load_balancer(){
  local load_balancer_name=$1

  aws elb describe-load-balancers \
    --load-balancer-name "${load_balancer_name}" \
  | jq '.LoadBalancerDescriptions[].BackendServerDescriptions[].PolicyNames[]' \
  || exit $?
}



main() {
  local load_balancer_name=$1

  if [ -z "$load_balancer_name" ]; then
    echo "./create.sh <load-balancer-name>"
    exit 1
  fi

  create_proxy_protocol_policy "${load_balancer_name}"
  set_proxy_protocol_policy "${load_balancer_name}"
  describe_load_balancer "${load_balancer_name}"
}
main $@
