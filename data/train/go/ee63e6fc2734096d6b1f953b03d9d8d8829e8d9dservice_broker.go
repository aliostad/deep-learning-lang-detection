package data

import (
	"strings"

	"github.com/deis/steward-framework"
	"k8s.io/client-go/pkg/api/unversioned"
	"k8s.io/client-go/pkg/api/v1"
)

const (
	ServiceBrokerKind       = "ServiceBroker"
	ServiceBrokerKindPlural = "ServiceBrokers"
)

// ServiceBrokerAPIResource returns an APIResource to describe the ServiceBroker third party
// resource
func ServiceBrokerAPIResource() *unversioned.APIResource {
	return &unversioned.APIResource{
		Name:       strings.ToLower(ServiceBrokerKindPlural),
		Namespaced: true,
		Kind:       ServiceBrokerKind,
	}
}

type ServiceBrokerState string

const (
	ServiceBrokerStatePending   ServiceBrokerState = "Pending"
	ServiceBrokerStateAvailable ServiceBrokerState = "Available"
	ServiceBrokerStateFailed    ServiceBrokerState = "Failed"
)

type ServiceBroker struct {
	unversioned.TypeMeta `json:",inline"`
	v1.ObjectMeta        `json:"metadata,omitempty"`

	Spec   framework.ServiceBrokerSpec
	Status ServiceBrokerStatus
}

type ServiceBrokerStatus struct {
	State ServiceBrokerState `json:"state"`
}
