package types

// DO NOT EDIT. THIS FILE WAS AUTOMATICALLY GENERATED

// SoftLayer_Network_LoadBalancer_Global_Type - The SoftLayer_Network_LoadBalancer_Global_Type data
// type represents a single load balance method that can be assigned to a global load balancer account.
// The load balance method determines how hosts in a load balancing pool are chosen by the global load
// balancers.
type SoftLayer_Network_LoadBalancer_Global_Type struct {

	// Id - no documentation
	Id int `json:"id,omitempty"`

	// Name - no documentation
	Name string `json:"name,omitempty"`
}

func (softlayer_network_loadbalancer_global_type *SoftLayer_Network_LoadBalancer_Global_Type) String() string {
	return "SoftLayer_Network_LoadBalancer_Global_Type"
}
