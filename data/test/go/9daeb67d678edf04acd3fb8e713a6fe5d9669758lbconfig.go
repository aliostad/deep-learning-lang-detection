package loadbalancer

import (
	"bytes"
	"fmt"
)

//loadBalancerFactories contains a name to factory mapping for all known load balancers. The Xavi framework
//will register its load balancers, and the RegisterLoadBalancerFactory function can be used by consumers
//who wish to extend the framework with their own load balancers.
var loadBalancerFactories map[string]LoadBalancerFactory

func init() {
	loadBalancerFactories = make(map[string]LoadBalancerFactory)

	//Round Robin
	var roundRobinFactory LoadBalancerFactory = new(RoundRobinLoadBalancerFactory)
	RegisterLoadBalancer("round-robin", roundRobinFactory)

	//Prefer Local
	var prefefLocalFactory LoadBalancerFactory = new(PreferLocalLoadBalancerFactory)
	RegisterLoadBalancer("prefer-local", prefefLocalFactory)
}

//RegisterLoadBalancer registers a load balancer factory with a given load balancer
//policy name. Once registered, the load balancer policy can be used in the configuration
//of a backend.
func RegisterLoadBalancer(policyName string, factory LoadBalancerFactory) error {
	if policyName == "" {
		return fmt.Errorf("Load balancer policy name must be specified")
	}

	if factory == nil {
		return fmt.Errorf("Load balancer factory may not be nil")
	}

	if IsKnownLoadBalancerPolicy(policyName) {
		return fmt.Errorf("Load balancer with name %s already present in factory", policyName)
	}

	loadBalancerFactories[policyName] = factory
	return nil
}

//IsKnownLoadBalancerPolicy returns true if the load balancer policy has been registered,
//false otherwise
func IsKnownLoadBalancerPolicy(policyName string) bool {
	f := loadBalancerFactories[policyName]
	return f != nil
}

//RegisteredLoadBalancers returns a string listing all registered load balanacers
func RegisteredLoadBalancers() string {
	var buffer bytes.Buffer
	first := true
	for k := range loadBalancerFactories {
		if first {
			first = false
		} else {
			buffer.WriteString(", ")
		}
		buffer.WriteString(k)
	}

	return buffer.String()
}

//ObtainFactoryForLoadBalancer returns the load balancer associated with the given policy.
func ObtainFactoryForLoadBalancer(policyName string) LoadBalancerFactory {
	return loadBalancerFactories[policyName]
}
