package sse

import (
	"net/http"
	"sync"
)

// ----------------------------------------------------------------------------------
//  types
// ----------------------------------------------------------------------------------

type Broker struct {
	clients map[string](map[int](chan []byte))
	mutex *sync.Mutex
}


// ----------------------------------------------------------------------------------
//  functions
// ----------------------------------------------------------------------------------

func NewBroker() *Broker {
	return &Broker{
		mutex: &sync.Mutex{},
		clients: make(map[string](map[int](chan []byte))),
	}
}


// ----------------------------------------------------------------------------------
//  members
// ----------------------------------------------------------------------------------

func (b *Broker) Group(name string) (*Group) {
	// create group entry if necessary
	group := b.clients[name]
	if group == nil {
		b.clients[name] = make(map[int](chan []byte))
	}

	// return the new group object
	return &Group{
		broker: b,
		name: name,
	}
}

func (b *Broker) ServeHTTP(rw http.ResponseWriter, req *http.Request) {
	// handle with the default group
	b.Group("").Handle(rw, req)
}
