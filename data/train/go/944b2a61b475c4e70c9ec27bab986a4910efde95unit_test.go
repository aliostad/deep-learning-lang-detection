package atomicbool

import (
	"runtime"
	"sync"
	"testing"
)

func TestLoad(t *testing.T) {
	data := struct {
		a, b, c, d, e, f bool
	}{true, true, true, true, true, true}

	if !LoadBool(&data.a) {
		t.Error("wrong")
	}
	data.a = false
	if LoadBool(&data.a) {
		t.Error("wrong")
	}

	if !LoadBool(&data.b) {
		t.Error("wrong")
	}
	data.b = false
	if LoadBool(&data.b) {
		t.Error("wrong")
	}

	if !LoadBool(&data.c) {
		t.Error("wrong")
	}
	data.c = false
	if LoadBool(&data.c) {
		t.Error("wrong")
	}

	if !LoadBool(&data.d) {
		t.Error("wrong")
	}
	data.d = false
	if LoadBool(&data.d) {
		t.Error("wrong")
	}

	if !LoadBool(&data.e) {
		t.Error("wrong")
	}
	data.e = false
	if LoadBool(&data.e) {
		t.Error("wrong")
	}

	if !LoadBool(&data.f) {
		t.Error("wrong")
	}
	data.f = false
	if LoadBool(&data.f) {
		t.Error("wrong")
	}
}

func TestStore(t *testing.T) {
	data := struct {
		a, b, c, d, e, f bool
	}{true, true, true, true, true, true}

	if !LoadBool(&data.a) {
		t.Error("wrong")
	}
	StoreBool(&data.a, false)
	if LoadBool(&data.a) {
		t.Error("wrong")
	}
	StoreBool(&data.a, true)
	if !LoadBool(&data.a) {
		t.Error("wrong")
	}

	if !LoadBool(&data.b) {
		t.Error("wrong")
	}
	StoreBool(&data.b, false)
	if LoadBool(&data.b) {
		t.Error("wrong")
	}
	StoreBool(&data.b, true)
	if !LoadBool(&data.b) {
		t.Error("wrong")
	}

	if !LoadBool(&data.c) {
		t.Error("wrong")
	}
	StoreBool(&data.c, false)
	if LoadBool(&data.c) {
		t.Error("wrong")
	}
	StoreBool(&data.c, true)
	if !LoadBool(&data.c) {
		t.Error("wrong")
	}

	if !LoadBool(&data.d) {
		t.Error("wrong")
	}
	StoreBool(&data.d, false)
	if LoadBool(&data.d) {
		t.Error("wrong")
	}
	StoreBool(&data.d, true)
	if !LoadBool(&data.d) {
		t.Error("wrong")
	}

	if !LoadBool(&data.e) {
		t.Error("wrong")
	}
	StoreBool(&data.e, false)
	if LoadBool(&data.e) {
		t.Error("wrong")
	}
	StoreBool(&data.e, true)
	if !LoadBool(&data.e) {
		t.Error("wrong")
	}

	if !LoadBool(&data.f) {
		t.Error("wrong")
	}
	StoreBool(&data.f, false)
	if LoadBool(&data.f) {
		t.Error("wrong")
	}
	StoreBool(&data.f, true)
	if !LoadBool(&data.f) {
		t.Error("wrong")
	}
}

// run this with -race
func TestRace(t *testing.T) {
	var b bool

	var wg sync.WaitGroup
	wg.Add(2)

	go func() {
		for i := 0; i < 100000; i++ {
			_ = LoadBool(&b)
			runtime.Gosched()
		}
		wg.Done()
	}()

	go func() {
		for i := 0; i < 100000; i++ {
			var v bool
			if (i & 1) != 0 {
				v = true
			}
			StoreBool(&b, v)
			runtime.Gosched()
		}
		wg.Done()
	}()

	wg.Wait()
}

func BenchmarkLoad(b *testing.B) {
	var x bool
	for i := 0; i < b.N; i++ {
		_ = LoadBool(&x)
	}
}

func BenchmarkStore(b *testing.B) {
	var x bool
	for i := 0; i < b.N; i++ {
		StoreBool(&x, true)
	}
}
