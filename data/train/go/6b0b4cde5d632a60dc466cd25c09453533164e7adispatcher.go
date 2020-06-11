package async

import(
	"log"
)

func StartDispatcher(handlerCount int) {
	DispatchQueue := make(chan chan Event, handlerCount)
	// creates the specified number of event handlers, each of which will add their
	// local event queues to the global dispatch queue.
	for i := 0; i < handlerCount; i++ {
		log.Printf("Starting asynchronous event handler %d", i+1)
		r := NewEventHandler(i+1, DispatchQueue)
		r.Start()
	}

	// forever, pops an event from the global event queue, and posts it to the local event queue of
	// the next available event handler from the dispatch queue.
	go func() {
		for {
			select {
			case event := <- EventQueue:
				go func() {
					availableEventQueue := <- DispatchQueue
					availableEventQueue <- event
				}()
			}
		}
	}()
}

