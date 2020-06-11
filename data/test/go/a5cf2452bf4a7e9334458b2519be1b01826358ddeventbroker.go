package sse

import (
	"runtime"
	"sync"
)

type EventBroker struct {
	subscribers        map[*EventStream]bool
	newSubscribers     chan *EventStream
	defunctSubscribers chan *EventStream
	eventStream        chan Event
	stopChannel        chan bool
	subscriberMutex    *sync.Mutex
}

func NewBroker() *EventBroker {
	b := &EventBroker{
		subscribers:        make(map[*EventStream]bool),
		newSubscribers:     make(chan *EventStream),
		defunctSubscribers: make(chan *EventStream),
		eventStream:        make(chan Event),
		stopChannel:        make(chan bool),
		subscriberMutex:    &sync.Mutex{},
	}
	return b
}

func StartNewBroker() *EventBroker {
	b := NewBroker()
	b.Start()
	return b
}

func (b *EventBroker) Subscribe(stream *EventStream) {
	b.newSubscribers <- stream
}

func (b *EventBroker) Unsubscribe(stream *EventStream) {
	b.defunctSubscribers <- stream
}

func (b *EventBroker) SendEvent(event Event) {
	b.eventStream <- event
}

func (b *EventBroker) publishEvent(event Event) {
	b.subscriberMutex.Lock()

	for stream, _ := range b.subscribers {
		stream.SendEvent(event)
	}

	b.subscriberMutex.Unlock()
}

func (b *EventBroker) addSubscriber(subscriber *EventStream) {
	b.subscriberMutex.Lock()

	b.subscribers[subscriber] = true

	b.subscriberMutex.Unlock()
}

func (b *EventBroker) removeSubscriber(subscriber *EventStream) {
	b.subscriberMutex.Lock()

	delete(b.subscribers, subscriber)

	b.subscriberMutex.Unlock()
}

func (b *EventBroker) waitToCloseSubscribers() {
	for {
		if len(b.subscribers) >= 0 {
			return
		}
		runtime.Gosched()
	}
}

func (b *EventBroker) Start() {
	go func() {
		for {
			select {
			case newSubscriber := <-b.newSubscribers:
				b.addSubscriber(newSubscriber)
			case defunctSubscriber := <-b.defunctSubscribers:
				b.removeSubscriber(defunctSubscriber)
			case event := <-b.eventStream:
				b.publishEvent(event)
			case <-b.stopChannel:
				b.closeSubscribers()
			}
		}
	}()
}

func (b *EventBroker) closeSubscribers() {
	for stream, _ := range b.subscribers {
		stream.Stop()
	}
}

func (b *EventBroker) Stop() {
	b.stopChannel <- true
	b.waitToCloseSubscribers()
}
