package main

import "sync"

// EventManager manages events and listeners
type EventManager struct {
	InputChannel  chan Event
	listenersLock sync.RWMutex
	listeners     []chan Event
}

// Listen listen to input channel
func (eventManager *EventManager) Listen() {
	for event := range eventManager.InputChannel {

		eventManager.listenersLock.RLock()
		for _, listener := range eventManager.listeners {
			listener <- event
		}
		eventManager.listenersLock.RUnlock()

	}
}

// AddListener add channel as a listener to message event
func (eventManager *EventManager) AddListener(ln chan Event) {
	eventManager.listenersLock.Lock()
	eventManager.listeners = append(eventManager.listeners, ln)
	eventManager.listenersLock.Unlock()
}

// RemoveListener removes channel from listeners
func (eventManager *EventManager) RemoveListener(rln chan Event) {
	eventManager.listenersLock.Lock()
	for i, ln := range eventManager.listeners {
		if ln == rln {
			eventManager.listeners = append(eventManager.listeners[:i], eventManager.listeners[i+1:]...)
			break
		}
	}
	eventManager.listenersLock.Unlock()
}

// NewEventManager creates new message managers
func NewEventManager() *EventManager {
	eventManager := &EventManager{
		InputChannel: make(chan Event, 100),
	}
	go eventManager.Listen()
	return eventManager
}
