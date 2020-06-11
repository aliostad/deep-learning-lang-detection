package goevent

import (
	"math/rand"
	"testing"
	"time"
)

const (
	TEST_EVENT = "test.event"
)

var d = NewDispatcher()

var testInc = 0

func TestPauseWait(t *testing.T) {
	d.ListenerFunc(TEST_EVENT, func(e Event, q chan int) {
		time.Sleep(time.Duration(rand.Intn(3)) * time.Second)
		e.Data.(*testing.T).Log("Event one")
		testInc++

		q <- 1
	})

	d.ListenerFunc(TEST_EVENT, func(e Event, q chan int) {
		time.Sleep(2 * time.Second)
		e.Data.(*testing.T).Log("Event two")
		testInc++

		q <- 1
	})

	event := Event{t, TEST_EVENT}
	d.Dispatch(event.Name, event)
	d.Pause()
	go func() {
		d.Dispatch(event.Name, event)
		d.Dispatch(event.Name, event)
		d.Dispatch(event.Name, event)
	}()
	time.Sleep(1 * time.Second)
	d.Resume()
	d.WaitAll()

	if testInc != 8 {
		t.Error("Invalid count")
	}
}
