package eventsourcing

// EventHandler represents a delegate that should be called when a new event has
// been dispatched.
type EventHandler func(evt Event)

// Dispatcher represents an event dispatcher which holds handlers.
type Dispatcher struct {
	handlers []EventHandler
}

// NewDispatcher instantiates a new dispatcher.
func NewDispatcher() *Dispatcher {
	return &Dispatcher{}
}

// AddHandlers adds one or more handlers to this dispatcher's instance.
func (d *Dispatcher) AddHandlers(handlers ...EventHandler) {
	d.handlers = append(d.handlers, handlers...)
}

// Dispatch dispatch one or more emitters changes to all registered handlers.
// It will pop changes and remove them from the emitter.
func (d *Dispatcher) Dispatch(emitters ...EventEmitter) {
	for _, emi := range emitters {
		for {
			evt := emi.PopChange()

			if evt == nil {
				break
			}

			d.DispatchEvents(evt)
		}
	}
}

// DispatchEvents dispatch one or more events to all registered handlers. You should not
// have to call it directly but just in case, its exposed.
func (d *Dispatcher) DispatchEvents(events ...Event) {
	for _, e := range events {
		for _, h := range d.handlers {
			h(e)
		}
	}
}
