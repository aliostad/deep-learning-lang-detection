package v1

import (
	"k8s.io/kubernetes/pkg/api/unversioned"
	kapi "k8s.io/kubernetes/pkg/api/v1"
)

const (
	// These are internal finalizer values to Origin
	FinalizerOrigin kapi.FinalizerName = "openshift.io/origin"

	// ServiceBrokerNew is create by administrator.
	ServiceBrokerNew ServiceBrokerPhase = "New"

	// ServiceBrokerRunning indicates that servicebroker service working well.
	ServiceBrokerActive ServiceBrokerPhase = "Active"

	// ServiceBrokerFailed indicates that servicebroker stopped.
	ServiceBrokerFailed ServiceBrokerPhase = "Failed"

	// ServiceBrokerDeleting indicates that servicebroker is going to be deleted.
	ServiceBrokerDeleting ServiceBrokerPhase = "Deleting"

	// ServiceBrokerLastPingTime indicates that servicebroker last ping time.
	PingTimer string = "ServiceBroker/LastPing"

	// ServiceBrokerNewRetryTimes indicates that new servicebroker retry times.
	ServiceBrokerNewRetryTimes string = "ServiceBroker/NewRetryTimes"

	// ServiceBrokerLastRefreshBSTime indicates that servicebroker last refresh backingservice time.
	RefreshTimer string = "ServiceBroker/LastRefresh"
)

type ServiceBrokerPhase string

// ServiceBroker describe a servicebroker
type ServiceBroker struct {
	unversioned.TypeMeta `json:",inline"`
	// Standard object's metadata.
	kapi.ObjectMeta `json:"metadata,omitempty"`

	// Spec defines the behavior of the Namespace.
	Spec ServiceBrokerSpec `json:"spec,omitempty" description:"spec defines the behavior of the ServiceBroker"`

	// Status describes the current status of a Namespace
	Status ServiceBrokerStatus `json:"status,omitempty" description:"status describes the current status of a ServiceBroker; read-only"`
}

// ServiceBrokerList is a list of ServiceBroker objects.
type ServiceBrokerList struct {
	unversioned.TypeMeta `json:",inline"`
	// Standard object's metadata.
	unversioned.ListMeta `json:"metadata,omitempty"`

	// Items is a list of routes
	Items []ServiceBroker `json:"items" description:"list of servicebrokers"`
}

// ServiceBrokerSpec describes the attributes on a ServiceBroker
type ServiceBrokerSpec struct {
	// url defines the address of a ServiceBroker service
	Url string `json:"url" description:"url defines the address of a ServiceBroker service"`
	// name defines the name of a ServiceBroker service
	Name string `json:"name" description:"name defines the name of a ServiceBroker service"`
	// username defines the username to access ServiceBroker service
	UserName string `json:"username" description:"username defines the username to access ServiceBroker service"`
	// password defines the password to access ServiceBroker service
	Password string `json:"password" description:"password defines the password to access ServiceBroker service"`
	// Finalizers is an opaque list of values that must be empty to permanently remove object from storage
	Finalizers []kapi.FinalizerName `json:"finalizers,omitempty" description:"an opaque list of values that must be empty to permanently remove object from storage"`
}

// ServiceBrokerStatus is information about the current status of a ServiceBroker
type ServiceBrokerStatus struct {
	// Phase is the current lifecycle phase of the project
	Phase ServiceBrokerPhase `json:"phase,omitempty" description:"phase is the current lifecycle phase of the servicebroker"`
}

const (
	ServiceBrokerLabel = "asiainfo.io/servicebroker"
)
