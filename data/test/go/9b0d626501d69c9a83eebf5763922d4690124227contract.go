package eventmanager

import (
	"time"
)

// Dispatcher interface
type DispatcherContract interface {
	Dispatch(eventName string, eventState interface{}, subscribers []Subscriber)
	GoDispatch(eventName string, eventState interface{}, subscribers []Subscriber)
}

// The storage interface
type Storage interface {
	Subscribers(string) []Subscriber
	Attach(string, Subscriber)
	DeAttach(string, Subscriber)
}

// The recorder interface
type Recorder interface {
	SnapShot(eventName string, eventPayload interface{}, on time.Time)
}

// The subscriber interface
type Subscriber interface {
	Update(interface{})
}
