package osbserver

import (
	"github.com/arschles/osbserver/request"
	"github.com/arschles/osbserver/response"
)

type Operations interface {
	Catalog() (*response.Catalog, *BrokerError)
	Provision(string, *request.Provision) (*response.Provision, *BrokerError)
	Deprovision(string) (*response.Deprovision, *BrokerError)
	PollLastOperation(string, *PollLastOperationParams) (*response.PollLastOperation, *BrokerError)
	UpdateInstance(string, *request.UpdateServiceInstance) (*response.UpdateServiceInstance, *BrokerError)
	Bind(string, string, *request.Bind) (*response.Bind, *BrokerError)
	Unbind(string, string) (*response.Unbind, *BrokerError)
}

type PollLastOperationParams struct {
	ServiceID string
	PlanID    string
	Operation string
}
