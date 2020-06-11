package models

import (
	"fmt"
	"net/url"
)

//Contains information about Domain Controller instances.
type DomainController  struct{
	RestEndpoint *url.URL `json:"restEndpoint" bson:"restEndpoint"`
	BrokerAddress *url.URL `json:"brokerAddress"`
	Domain    *RealWorldDomain `json:"domain" bson:"domain"`
}

func NewDomainController(restEndpoint *url.URL,brokerAddress *url.URL, domain *RealWorldDomain) *DomainController {
	controller := new(DomainController)
	controller.BrokerAddress = brokerAddress
	controller.RestEndpoint = restEndpoint
	controller.Domain = domain
	return controller
}

func (controller *DomainController) String() string {
	return fmt.Sprintf("Rest-Endpoint: %s,Broker Address: %s, Domain: %s",controller.RestEndpoint,controller.BrokerAddress, controller.Domain)
}