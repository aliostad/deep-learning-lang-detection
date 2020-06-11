package events

import "sort"

// Event represents one event. Event must have an Exec method which takes a context. A context
// can be interface{}. Since in most cases it is desiderable to hint the actual type of your context,
// forcing interface{} as an argument for the method is no option. As a limitation of Go's type
// system, no method is implemented in the interface at all.
//
// Events with no Exec method will not be executed
type Event interface{}

// prioritizedEvent is used internally to define the point of execution of an event.
type prioritizedEvent struct {
	// ev is the Event
	ev Event
	// prio is the event priority
	prio uint
}

// EventCollection contains a slice of prioritized events.
type EventCollection struct {
	// events contains a list of prioritized events, thus, events and their
	// priority. Developers should not rely on the order of this slice
	// as the priority is embedded in the events and the sorting may vary
	// when calling the sort() method.
	events []*prioritizedEvent
	// hp contains the current highest priority to avoid unnecessary
	// runtime complexity. The prioritizedEvent is immutable from a user's
	// perspective, therefore can't be manipulated and hp will stay valid.
	hp uint
}

func (e *EventCollection) AddEvent(event Event, priority uint) {
	e.events = append(e.events, &prioritizedEvent{event, priority})
	e.refreshHp(priority)
}

func (e *EventCollection) AppendEvent(event Event) {
	e.AddEvent(event, e.hp+1)
}

// refreshHp will refresh the highest priority "hp" used by the AppendEvent function
func (e *EventCollection) refreshHp(hp uint) {
	if hp > e.hp {
		e.hp = hp
	}
}

// Len implements sort.Interface
func (e *EventCollection) Len() int {
	return len(e.events)
}

// Swap implements sort.Interface
func (e *EventCollection) Swap(i, j int) {
	e.events[i], e.events[j] = e.events[j], e.events[i]
}

// Less implements sort.Interface
func (e *EventCollection) Less(i, j int) bool {
	return e.events[i].prio < e.events[j].prio
}

// sort is a shortcut method to sort contained events by priority
func (e *EventCollection) sort() {
	sort.Sort(e)
}

// Dispatch the event collection with the given context.
//
// Dispatch is a shorthand method to call DispatchEvents from the EventCollection. It will
// just call DispatchEvents()
func (e *EventCollection) Dispatch(withContext interface{}) {
	DispatchEvents(e, withContext)
}

// Dispatch the event collection with the given context and a callback function.
// For more information about the callback function, see DispatchEventsCallback().
//
// DispatchCallback is a shorthand method to call DispatchEventsCallback from the EventCollection.
// It will just call DispatchEvents()
func (e *EventCollection) DispatchCallback(withContext interface{}, callback OnReturnFN) {
	DispatchEventsCallback(e, withContext, callback)
}
