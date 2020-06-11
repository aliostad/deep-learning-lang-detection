package roll

import (
	"testing"
)

func TestManager(t *testing.T) {
	manager := NewManager(10)

	i := manager.Get("foo")
	if i > 0 {
		t.Fatal("expected count 0 got", i)
	}
	manager.Incr("foo")
	i = manager.Get("foo")
	if i != 1 {
		t.Fatal("expected count 1 got", i)
	}
	manager.Slide("foo")
	i = manager.Get("foo")
	if i > 0 {
		t.Fatal("expected count 0 got", i)
	}
	i = manager.Total("foo")
	if i != 1 {
		t.Fatal("expected count 1 got", i)
	}
	manager.Incr("foo")
	i = manager.Total("foo")
	if i != 2 {
		t.Fatal("expected count 2 got", i)
	}
}
