package async

import (
	"log"
)

type EventHandler struct {
	ID int
	DispatchQueue chan chan Event
}

func NewEventHandler(id int, dispatchQueue chan chan Event) EventHandler {
	return EventHandler {
		ID: id,
		DispatchQueue: dispatchQueue,
	}
}

// Event processing loop
func (h *EventHandler) Start() {
	// local event queue
	eventQueue := make(chan Event)
	go func() {
		for {
			// posts its local event queue to the dispatch queue.
			h.DispatchQueue <- eventQueue
			// receives events from the dispatcher.
			select {
			case event := <- eventQueue:
				log.Printf("Asynchronous event handler %d is processing an event.\n", h.ID)
				event.Process()
			}
		}
	}()
}


