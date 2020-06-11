package balancer

import (
	"fmt"
	"github.com/centurylinkcloud/clc-go-cli/base"
)

type LoadBalancer struct {
	LoadBalancerId   string
	LoadBalancerName string
	DataCenter       string
}

func (b *LoadBalancer) Validate() error {
	if b.DataCenter == "" {
		return fmt.Errorf("DataCenter: non-zero value required.")
	}

	if (b.LoadBalancerId == "") == (b.LoadBalancerName == "") {
		return fmt.Errorf("Exactly one of the load-balancer-id and load-balancer-name properties must be specified.")
	}
	return nil
}

func (b *LoadBalancer) InferID(cn base.Connection) error {
	if b.LoadBalancerName == "" {
		return nil
	}

	id, err := IDByName(cn, b.DataCenter, b.LoadBalancerName)
	if err != nil {
		return err
	}
	b.LoadBalancerId = id
	return nil
}

func (b *LoadBalancer) GetNames(cn base.Connection, property string) ([]string, error) {
	if property != "LoadBalancerName" {
		return nil, nil
	}

	return GetNames(cn, b.DataCenter)
}
