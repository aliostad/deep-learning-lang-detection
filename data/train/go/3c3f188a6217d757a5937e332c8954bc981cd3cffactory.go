package wfe

import (
	"fmt"
	"net/url"
	"sync"
)

var (
	brokers  = make(map[string]BrokerFactory)
	stores   = make(map[string]ResultStoreFactory)
	graphers = make(map[string]GraphBackendFactory)

	bm sync.Mutex
	sm sync.Mutex
	gm sync.Mutex
)

//BrokerFactory function type
type BrokerFactory func(u *url.URL) (Broker, error)

//ResultStoreFactory function type
type ResultStoreFactory func(u *url.URL) (ResultStore, error)

//GraphBackend factory function type
type GraphBackendFactory func(u *url.URL) (GraphBackend, error)

//Options is used to configure both the Engine and the Client instances. It specifies the broker and the result store
//to use
type Options struct {
	//Broker URL `amqp://localhost:5672`
	Broker string

	//Store URL `redis://localhost:6379?keep=30`
	Store string

	//Graph backend URL
	Graph string
}

/*
RegisterBroker is used to register a broker factory. In case you need to implement your own broker layer.
WFE package implements the `amqp` broker which uses rabbitmq

	RegisterBroker('fake', fakeFactory)

	o := &Options{
		Broker: "fake://host/?args",
	}
*/
func RegisterBroker(scheme string, factory BrokerFactory) {
	bm.Lock()
	defer bm.Unlock()

	brokers[scheme] = factory
}

//RegisterResultStore is used to register a result store factory. In case you need to implement your own store layer.
//WFE package implements
func RegisterResultStore(scheme string, factory ResultStoreFactory) {
	sm.Lock()
	defer sm.Unlock()

	stores[scheme] = factory
}

func RegisterGraphBackend(scheme string, factory GraphBackendFactory) {
	gm.Lock()
	defer gm.Unlock()

	graphers[scheme] = factory
}

//GetBroker gets a new instance of the broker according to the broker url
func (o *Options) GetBroker() (Broker, error) {
	u, err := url.Parse(o.Broker)
	if err != nil {
		log.Errorf("failed to parse broker url: %s", o.Broker)
		return nil, err
	}

	bm.Lock()
	defer bm.Unlock()

	factory, ok := brokers[u.Scheme]
	if !ok {
		return nil, fmt.Errorf("unknown broker %s", u.Scheme)
	}

	return factory(u)
}

//GetStore gets a new instance of the result store according to the store url
func (o *Options) GetStore() (ResultStore, error) {
	if o.Store == "" {
		return (*discardStore)(nil), nil
	}

	u, err := url.Parse(o.Store)
	if err != nil {
		log.Errorf("failed to parse broker url: %s", o.Broker)
		return nil, err
	}

	sm.Lock()
	defer sm.Unlock()

	factory, ok := stores[u.Scheme]
	if !ok {
		return nil, fmt.Errorf("unknown store %s", u.Scheme)
	}

	return factory(u)
}

func (o *Options) GetGraphBackend() (GraphBackend, error) {
	if o.Graph == "" {
		return (*noopGrapher)(nil), nil
	}

	u, err := url.Parse(o.Graph)
	if err != nil {
		log.Errorf("failed to parse graph backend url: %s", o.Broker)
		return nil, err
	}

	gm.Lock()
	defer gm.Unlock()

	factory, ok := graphers[u.Scheme]
	if !ok {
		return nil, fmt.Errorf("unknown graph backend %s", u.Scheme)
	}

	return factory(u)
}
