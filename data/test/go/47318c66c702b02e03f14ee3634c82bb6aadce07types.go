package api

import (
	kapi "k8s.io/kubernetes/pkg/api"
	"k8s.io/kubernetes/pkg/api/unversioned"
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

type ServiceBroker struct {
	unversioned.TypeMeta
	kapi.ObjectMeta

	// Spec defines the behavior of the Namespace.
	Spec ServiceBrokerSpec

	// Status describes the current status of a Namespace
	Status ServiceBrokerStatus
}

type ServiceBrokerList struct {
	unversioned.TypeMeta
	unversioned.ListMeta

	Items []ServiceBroker
}

type ServiceBrokerSpec struct {
	Url      string
	Name     string
	UserName string
	Password string

	Finalizers []kapi.FinalizerName
}

type ServiceBrokerStatus struct {
	Phase ServiceBrokerPhase
}

const (
	ServiceBrokerLabel = "asiainfo.io/servicebroker"
)
