package event

import "github.com/golang/glog"

// Dispatcher is an event dispatcher
type Dispatcher interface {
	// Dispatch dispatches an event
	Dispatch(event Event) error
}

// NopDispatcher is a no-operation event dispatcher
type NopDispatcher struct {
	log bool
}

// Dispatch does nothing but implements event.Dispatcher
func (d *NopDispatcher) Dispatch(event Event) error {
	if d.log {
		glog.Info("[event] ", event.URN())
	}
	return nil
}

// NewNopDispatcher returns a new NopDispatcher that optionally logs
// events at Info level
func NewNopDispatcher(log bool) Dispatcher {
	return &NopDispatcher{
		log: log,
	}
}
