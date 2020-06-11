package rollerskates

type LoadBalancerInstanceRemover interface {
	RemoveFromLoadBalancer(loadBalancerName string, instanceId string) bool
}

type InstanceRestarter interface {
	RestartInstance(id string) bool
}

type LoadBalancerInstanceAdder interface {
	AddInstanceToLoadBalancer(loadBalancerName string, instanceId string) bool
}

type RestartLoadBalancerInstanceDependencies struct {
	remover   LoadBalancerInstanceRemover
	restarter InstanceRestarter
	adder     LoadBalancerInstanceAdder
}

func RestartLoadBalancerInstance(deps RestartLoadBalancerInstanceDependencies, loadBalancerName string, instanceId string) {
	removalSuccessful := deps.remover.RemoveFromLoadBalancer(loadBalancerName, instanceId)
	if removalSuccessful {
		restartSuccessful := deps.restarter.RestartInstance(instanceId)
		if restartSuccessful {
			deps.adder.AddInstanceToLoadBalancer(loadBalancerName, instanceId)
		}
	}
}
