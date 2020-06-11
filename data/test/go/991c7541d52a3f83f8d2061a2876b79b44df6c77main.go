package main

import (
	"fmt"
	"sync"
)

// +gen signal
type Event struct {
	ID   int
	Type string
}

func main() {
	var wg sync.WaitGroup
	var signal EventSignal

	for i := 0; i < 3; i++ {
		wg.Add(1)
		c := make(chan Event)
		signal.Add(c)
		go func(i int) {
			for event := range c {
				fmt.Printf("Listener %d: %v\n", i, event)
				if event.Type == "disconnect" {
					break
				}
			}

			wg.Done()
		}(i)
	}

	signal.Dispatch(Event{ID: 1, Type: "connect"})
	signal.Dispatch(Event{ID: 2, Type: "work"})
	signal.Dispatch(Event{ID: 3, Type: "disconnect"})

	wg.Wait()
}

// Sample output
//
// Listener 0: {1 connect}
// Listener 1: {1 connect}
// Listener 1: {2 work}
// Listener 2: {1 connect}
// Listener 0: {2 work}
// Listener 2: {2 work}
// Listener 2: {3 disconnect}
// Listener 0: {3 disconnect}
// Listener 1: {3 disconnect}
