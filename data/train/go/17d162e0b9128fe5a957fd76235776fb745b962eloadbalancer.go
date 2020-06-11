package model

import (
	"strings"

	goelb "github.com/aws/aws-sdk-go/service/elb"
	"github.com/aws/aws-sdk-go/service/elbv2"
)

// LoadBalancers represents an slice of loadbalancer.
type LoadBalancers []*LoadBalancer

// NewLoadBalancers creates the object of LoadBalancers from the slice of elb.LoadBalancerDescription.
func NewLoadBalancers(descs []*goelb.LoadBalancerDescription) LoadBalancers {
	var lbs LoadBalancers
	for _, desc := range descs {
		lbs = append(lbs, NewLoadBalancer(desc))
	}
	return lbs
}

// NewLoadBalancersByInstanceID creates the object of LoadBalancers from elb.LoadBalancerDescription.
func NewLoadBalancersByInstanceID(descs []*goelb.LoadBalancerDescription, instanceID string) LoadBalancers {
	var lbs LoadBalancers
	for _, desc := range descs {
		for _, instance := range desc.Instances {
			if *instance.InstanceId == instanceID {
				lbs = append(lbs, NewLoadBalancer(desc))
			}
		}
	}
	return lbs
}

// NewLoadBalancersFromALB creates the object of LoadBalancers from ALB.
func NewLoadBalancersFromALB(loadBalancers []*elbv2.LoadBalancer,
	loadBalancerArnToTargets map[string][]*elbv2.TargetDescription) LoadBalancers {
	models := make(LoadBalancers, 0, len(loadBalancers))
	for _, lb := range loadBalancers {
		targets := loadBalancerArnToTargets[*lb.LoadBalancerArn]
		models = append(models, NewLoadBalancerFromALB(lb, targets))
	}
	return models
}

// String returns a string reprentation of LoadBalancers.
func (lbs LoadBalancers) String() string {
	return strings.Join(lbs.NameSlice(), ",")
}

// NameSlice returns a slice of loadbalancer's name.
func (lbs LoadBalancers) NameSlice() []string {
	names := make([]string, 0, len(lbs))
	for _, lb := range lbs {
		names = append(names, lb.Name)
	}
	return names
}

// NamePointerSlice returns a slice of loadbalancer's name.
func (lbs LoadBalancers) NamePointerSlice() []*string {
	names := make([]*string, 0, len(lbs))
	for _, lb := range lbs {
		name := lb.Name
		names = append(names, &name)
	}
	return names
}

// LoadBalancer represents a loadbalancer.
type LoadBalancer struct {
	Name      string      `json:"name"`
	DNSName   string      `json:"dnsname"`
	Instances []*Instance `json:"instances"`
}

// NewLoadBalancer creates a LoadBalancer object from elb.LoadBalancerDescription.
func NewLoadBalancer(desc *goelb.LoadBalancerDescription) *LoadBalancer {
	instances := make([]*Instance, 0, len(desc.Instances))
	for _, instance := range desc.Instances {
		instances = append(instances, NewInstance(instance))
	}
	return &LoadBalancer{
		Name:      *desc.LoadBalancerName,
		DNSName:   *desc.DNSName,
		Instances: instances,
	}
}

func NewLoadBalancerFromALB(desc *elbv2.LoadBalancer, targets []*elbv2.TargetDescription) *LoadBalancer {
	instances := make([]*Instance, 0, len(targets))
	for _, target := range targets {
		instances = append(instances, NewInstanceFromTarget(target))
	}
	return &LoadBalancer{
		Name:      *desc.LoadBalancerName,
		DNSName:   *desc.DNSName,
		Instances: instances,
	}
}

// String returns a string reprentation of LoadBalancer.
func (l *LoadBalancer) String() string {
	return l.Name
}
