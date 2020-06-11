package events

import "reflect"

var LastError string = ""

// OnReturnFN is the function which is executed after the event is dispatched. If the event returned
// data, the reflection representation of the data will be passed to the function as first
// argument. The function is executed regardless of the contents of the return
type OnReturnFN func([]reflect.Value)

// DispatchEvent dispatches a single event with a context
func DispatchEvent(ev Event, withContext interface{}) {
	// Dispatch an event with no callback by calling the DispatchEventCallback function
	// with a nil callback.
	DispatchEventCallback(ev, withContext, nil)
}

// DispatchEventCallback dispatches a single event with a context and a callback function
func DispatchEventCallback(ev Event, withContext interface{}, callback OnReturnFN) {
	// The internal dispatcher requires a reflection representation of the context
	ctx := createContext(withContext)
	dispatchEvent(ev, ctx, callback)
}

// DispatchEvents dispatches an EventCollection with a context
func DispatchEvents(evs *EventCollection, withContext interface{}) {
	DispatchEventsCallback(evs, withContext, nil)
}

// DispatchEvents dispatches an EventCollection with a context and a callback function
func DispatchEventsCallback(evs *EventCollection, withContext interface{}, callback OnReturnFN) {
	evs.sort()
	ctx := createContext(withContext)
	for _, ec := range evs.events {
		dispatchEvent(ec.ev, ctx, callback)
	}
}

// dispatchEvent is the central function to dispatch an event. All other dispatching methods
// will call this one on some level. When facing issues with the event system, this function
// is the best point to set breakpoints.
//
// Please consider the further explanations on non-strict handling.
func dispatchEvent(ev Event, ctx []reflect.Value, callback OnReturnFN) {
	// Create a reflection representation of the event
	rev := reflect.ValueOf(ev)
	// Get the Exec method. If the Exec method does not exist, an empty reflect value
	// is returned.
	method := rev.MethodByName("Exec")

	// Assert that the Exec method actually exists. If no Exec method exists, the system
	// stop the execution of this event. To avoid a runtime-panic, the error gets pushed to
	// the LastError variable.
	//
	// Consider setting a breakpoint on the assignment line of LastError for debugging purposes
	// when facing problems with the event dispatcher.
	if method.Kind() != reflect.Func {
		LastError = "Event " + rev.String() + " has no Exec method. An Exec method is required."
		return
	}

	ret := method.Call(ctx)

	if callback != nil {
		callback(ret)
	}
}

func createContext(context interface{}) []reflect.Value {
	return []reflect.Value{reflect.ValueOf(context)}
}
