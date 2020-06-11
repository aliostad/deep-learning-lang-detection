package rollerskates

type RestartLoadBalancerInstancesDependencies struct {
	restarter             LoadBalancerInstanceRestarter
	restarterDependencies RestartLoadBalancerInstanceDependencies
	lister                LoadBalancerInstanceLister
	InstanceIdsRetriever  InstanceIdsRetriever
}

type LoadBalancerInstanceRestarter interface {
	RestartLoadBalancerInstance(deps RestartLoadBalancerInstanceDependencies, loadBalancerName string, instanceId string)
}
type LoadBalancerInstanceLister interface {
	ListLoadBalancerInstances(retriever InstanceIdsRetriever, loadBalancerName string) []LoadBalancerInstance
}

func RestartLoadBalancerInstances(deps RestartLoadBalancerInstancesDependencies, loadBalancerName string) {
	instances := deps.lister.ListLoadBalancerInstances(deps.InstanceIdsRetriever, loadBalancerName)
	for _, instance := range instances {
		deps.restarter.RestartLoadBalancerInstance(deps.restarterDependencies, loadBalancerName, instance.id)
	}
}
