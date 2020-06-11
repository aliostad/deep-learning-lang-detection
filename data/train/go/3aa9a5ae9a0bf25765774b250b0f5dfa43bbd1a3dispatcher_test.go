// chrisguitarguy/disptach
// Copyright: 2013 Christopher Davis <http://christopherdavis.me>
// License: MIT

package dispatch

import "testing"

func TestAddHasListeners(t *testing.T) {
	d := NewDispatcher()

	if d.HasListeners("an_event") {
		t.Error(`"an_event" should not have any listeners`)
	}

	l := NewListener(10, func (e Event, d Dispatcher) {
		// noop
	})

	d.AddListener("an_event", l)

	if !d.HasListeners("an_event") {
		t.Error(`"an_event" should have listeners, AddListener called`)
	}
}

func TestDispatch(t *testing.T) {
	d := NewDispatcher()

	l1 := NewListener(10, func(e Event, d Dispatcher) {
		t.Error("Listener should not have been called")
	});

	l2 := NewListener(20, func(e Event, d Dispatcher) {
		t.Log("Called l2")
		e.StopPropogation()
	});

	d.AddListener("an_event", l1)
	d.AddListener("an_event", l2)

	d.Dispatch("a_event", NewEvent("eventName"))
}
