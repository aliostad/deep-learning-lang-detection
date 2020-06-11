package broker

import (
	"fmt"
)

type BrokerDriver interface {
	Catalog() interface{}
}

type Broker struct {
	driver BrokerDriver
}

var brokers = make(map[string]BrokerDriver)

func register(name string, broker BrokerDriver) {
	if broker == nil {
		panic("broker: Register broker is nil")
	}
	if _, dup := brokers[name]; dup {
		panic("broker: Register called twice for broker " + name)
	}
	brokers[name] = broker
}

func New(name string) (*Broker, error) {
	broker, ok := brokers[name]
	if !ok {
		return nil, fmt.Errorf("Can't find broker %s", name)
	}
	return &Broker{driver: broker}, nil
}

func (broker *Broker) Catalog() {
	broker.driver.Catalog()
}
func (broker *Broker) Provisioning() {
	fmt.Println("Provisioning not implement.")
}
func (broker *Broker) Binding() {
	fmt.Println("Binding not implement.")
}
