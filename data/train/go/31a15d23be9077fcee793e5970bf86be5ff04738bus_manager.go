package event

import (
    "fmt"
)

/*
 * Basic types
 */
type Event struct {
    Kind
    *Identity
    Data []interface{}
}
type EventBus chan *Event


/*
 * BusManager
 */
type BusManager struct {
    incoming chan Event
    outgoings map[Kind][]chan Event
    done chan bool
    running bool
}

func NewBusManager() *BusManager {
    return new(BusManager)
}

func (busManager BusManager) Running() bool {
    return busManager.running
}

func (busManager *BusManager) setupChannels() {
    busManager.incoming = make(chan Event, 0)
    busManager.done = make(chan bool, 0)
    busManager.outgoings = make(map[Kind][]chan Event, len(allKinds))
    for _, kind := range allKinds {
        busManager.outgoings[kind] = make([]chan Event, 0, 5)
    }
}

func (busManager *BusManager) cleanupChannels() {
    close(busManager.done)
    close(busManager.incoming)
    for _, channels := range busManager.outgoings {
        for _, channel := range channels {
            close(channel)
        }
    }
}

func (busManager *BusManager) Start() {
    busManager.setupChannels()
    go func() {
        busManager.running = true
        for {
            select {
            case event := <- busManager.incoming:
                for _, outgoing := range busManager.outgoings[event.Kind] {
                    outgoing <- event
                }
            case <- busManager.done:
                break
            }
        }
        busManager.running = false
        busManager.cleanupChannels()
    }()
}

func (busManager *BusManager) Stop() {
    busManager.done <- true
}

func (busManager *BusManager) PublishEvent(kind Kind,
        identity *Identity, data []interface{}) bool {
    if busManager == nil {
        panic(fmt.Errorf("*BusManager.PublishEvent(): bus manager is nil"))
    }
    if busManager.running {
        event := Event{kind, identity, data}
        busManager.incoming <- event
        return true
    }
    return false
}

func (busManager *BusManager) SubscribeTo(kinds []Kind) (<-chan Event) {
    outgoing := make(chan Event, 0)
    for _, kind := range kinds {
        busManager.outgoings[kind] = append(busManager.outgoings[kind], outgoing)
    }
    return outgoing
}

func (busManager *BusManager) SubscribeToEvent(kind Kind) (<-chan Event) {
    return busManager.SubscribeTo([]Kind{kind})
}

func (busManager *BusManager) SubscribeToAll() (<-chan Event) {
    return busManager.SubscribeTo(allKinds)
}
