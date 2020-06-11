package servicebroker

import (
	"github.com/deis/steward-framework/k8s/data"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/pkg/watch"
)

// WatchServiceBrokerFunc is the function that returns a watch interface for service broker
// resources
type WatchServiceBrokerFunc func(namespace string) (watch.Interface, error)

// NewK8sWatchServiceBrokerFunc returns a WatchServiceBrokerFunc backed by a Kubernetes client
func NewK8sWatchServiceBrokerFunc(cl *dynamic.Client) WatchServiceBrokerFunc {
	return func(namespace string) (watch.Interface, error) {
		resCl := cl.Resource(data.ServiceBrokerAPIResource(), namespace)
		return resCl.Watch(&data.ServiceBroker{})
	}
}
