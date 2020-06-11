package graphblast

import (
	"testing"
)

func TestBroadcaster(t *testing.T) {
	broadcaster := NewBroadcaster()
	go broadcaster.DispatchForever()

	messages := broadcaster.Subscribe("foo")
	broadcaster.Send(NewJSONMessage("test", struct{ Value int }{1}))
	msg := <-messages
	if msg == nil {
		t.Error("Dispatch sent a nil message")
	}
	if msg.Envelope() != "test" {
		t.Error("Dispatched message had the wrong envelope")
	}
	contents, err := msg.Contents()
	if err != nil {
		t.Error("Error getting the contents of the dispatched message")
	}
	if string(contents) != `{"Value":1}` {
		t.Error("Dispatched message had the wrong contents")
	}
}
