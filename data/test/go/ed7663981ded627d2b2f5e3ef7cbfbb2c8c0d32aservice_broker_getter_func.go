package refs

import (
	"github.com/deis/steward-framework/k8s/data"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/pkg/api"
)

// ServiceBrokerGetterFunc is the function that attempts to retrieve a service broker at the given
// object ref
type ServiceBrokerGetterFunc func(api.ObjectReference) (*data.ServiceBroker, error)

// NewK8sServiceBrokerGetterFunc returns a ServiceBrokerGetterFunc  backed by a real kubernetes
// client
func NewK8sServiceBrokerGetterFunc(cl *dynamic.Client) ServiceBrokerGetterFunc {
	return func(ref api.ObjectReference) (*data.ServiceBroker, error) {
		resCl := cl.Resource(data.ServiceBrokerAPIResource(), ref.Namespace)
		unstruc, err := resCl.Get(ref.Name)
		if err != nil {
			return nil, err
		}
		retServiceBroker := new(data.ServiceBroker)
		if err := data.TranslateToTPR(unstruc, retServiceBroker, data.ServiceBrokerKind); err != nil {
			return nil, err
		}
		return retServiceBroker, nil
	}
}

// NewFakeServiceBrokerGetterFunc returns a fake ServiceBrokerGetterFunc. If retErr is non-nil, it
// always returns (nil, retErr). Otherwise returns (serviceBroker, nil)
func NewFakeServiceBrokerGetterFunc(
	serviceBroker *data.ServiceBroker,
	retErr error,
) ServiceBrokerGetterFunc {
	return func(api.ObjectReference) (*data.ServiceBroker, error) {
		if retErr != nil {
			return nil, retErr
		}
		return serviceBroker, nil
	}
}
