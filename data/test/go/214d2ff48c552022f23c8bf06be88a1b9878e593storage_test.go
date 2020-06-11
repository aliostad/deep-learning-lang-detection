package memcached

import (
	"fmt"
	"testing"
)

func Test_Storage(t *testing.T) {
	s := NewStorage()
	req := new(MemRequest)
	req.Op = GET
	req.Key = "a"
	go func() {
		s.Loop()
	}()
	s.Dispatch(req)
	s.Dispatch(req)
}

func Benchmark_Set(b *testing.B) {
	s := NewStorage()
	go func() {
		s.Loop()
	}()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		key := fmt.Sprintf("%d", i)
		req := &MemRequest{Op: SET, Key: key, Data: []byte("8888888888"), Flags: 0, Exptime: 0, Value: 10}
		s.Dispatch(req)
	}
	s.T_exit()
}
