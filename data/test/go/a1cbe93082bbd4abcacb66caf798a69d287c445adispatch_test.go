package flux

import "testing"
import "time"

func TestDispatch(t *testing.T) {
	s := &StoreTest{}
	Register(s)
	defer Unregister(s)

	a := Action{
		Name:    "Action-Test",
		Payload: 42,
	}
	Dispatch(a, a)

	time.Sleep(time.Millisecond)

	if !s.OnDispatched {
		t.Error("s.OnDispatched should be true")
	}

	Dispatch()
}

func TestDispatchError(t *testing.T) {
	s := &StoreTest{
		ThrowError: true,
	}
	Register(s)
	defer Unregister(s)

	a := Action{
		Name:    "Action-Test",
		Payload: 42,
	}
	Dispatch(a, a)

	time.Sleep(time.Millisecond)

	if s.OnDispatched {
		t.Error("s.OnDispatched should be false")
	}
}

func BenchmarkDispatch(b *testing.B) {
	b.StopTimer()

	for i := 0; i < 42; i++ {
		Register(&StoreTest{})
	}

	b.StartTimer()

	for i := 0; i < b.N; i++ {
		a := Action{
			Name:    "Action-Test",
			Payload: 42,
		}
		Dispatch(a, a, a)
	}
}
