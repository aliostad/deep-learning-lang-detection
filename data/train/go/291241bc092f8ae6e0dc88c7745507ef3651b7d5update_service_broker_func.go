package servicebroker

import (
	"github.com/deis/steward-framework/k8s/data"
	"k8s.io/client-go/dynamic"
)

// UpdateServiceBrokerFunc is the function that can update a service broker
type UpdateServiceBrokerFunc func(*data.ServiceBroker) (*data.ServiceBroker, error)

// NewK8sUpdateServiceBrokerFunc returns an UpdateServiceBrokerFunc backed by a Kubernetes client
func NewK8sUpdateServiceBrokerFunc(cl *dynamic.Client) UpdateServiceBrokerFunc {
	return func(newServiceBroker *data.ServiceBroker) (*data.ServiceBroker, error) {
		resCl := cl.Resource(data.ServiceBrokerAPIResource(), newServiceBroker.Namespace)
		unstruc, err := data.TranslateToUnstructured(newServiceBroker)
		if err != nil {
			return nil, err
		}
		retUnstruc, err := resCl.Update(unstruc)
		if err != nil {
			return nil, err
		}
		retServiceBroker := new(data.ServiceBroker)
		if err := data.TranslateToTPR(retUnstruc, retServiceBroker, data.ServiceBrokerKind); err != nil {
			return nil, err
		}
		return retServiceBroker, nil
	}
}
