package broker

import "github.com/pivotal-cf/brokerapi"

type Broker struct {
}

func (Broker) Services() []brokerapi.Service {
	// Return a []brokerapi.Service here, describing your service(s) and plan(s)
	return []brokerapi.Service{}
}

func (Broker) Provision(instanceID string, serviceDetails brokerapi.ServiceDetails) error {
	// Provision a new instance here

	return nil
}

func (Broker) Deprovision(instanceID string) error {
	// Deprovision instances here
	return nil
}

func (Broker) Bind(instanceID, bindingID string) (interface{}, error) {
	// Bind to instances here
	// Return credentials which will be marshalled to JSON
	return nil, nil
}

func (Broker) Unbind(instanceID, bindingID string) error {
	// Unbind from instances here
	return nil
}
