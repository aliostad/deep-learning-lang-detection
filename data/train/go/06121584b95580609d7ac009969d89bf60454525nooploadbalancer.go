package loadbalancer

import (
	"fmt"
)

type NoopLoadBalancer struct {
	Namespace string
}

func (s *NoopLoadBalancer) Configure(namespace string) {
	if s.Namespace != "" {
		//TODO: use logging
		fmt.Errorf("%s already inited: %s", FactoryKey, s.Namespace)
		return
	}
	s.Namespace = namespace
}

func (s *NoopLoadBalancer) GetNamespace() string {
	return s.Namespace
}

func (s *NoopLoadBalancer) Choose() *Server {
	return nil
}

var FactoryKey = "NoopLoadBalancer"

func NewNoopLoadBalancer() LoadBalancer {
	return &NoopLoadBalancer{}
}

func init() {
	Register(FactoryKey, NewNoopLoadBalancer)
}
