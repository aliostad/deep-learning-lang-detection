package eventmanager

type Dispatcher bool

// Dispatches the event in sequential
func (d *Dispatcher) Dispatch(eventName string, eventState interface{}, subscribers []Subscriber) {
	dispatch(subscribers, eventName, eventState, false)
}

// Dispatches the event in routines
func (d *Dispatcher) GoDispatch(eventName string, eventState interface{}, subscribers []Subscriber) {
	dispatch(subscribers, eventName, eventState, true)
}

// Dispatches the event across all the subscribers
func dispatch(subscribers []Subscriber, eventName string, eventState interface{}, async bool) {
	if async {
		for _, subscriber := range subscribers {
			go subscriber.Update(eventState)
		}
	} else {
		for _, subscriber := range subscribers {
			subscriber.Update(eventState)
		}
	}
}

// Factory method for the event manager dispatcher
func NewDispatcher() *Dispatcher {
	return new(Dispatcher)
}
