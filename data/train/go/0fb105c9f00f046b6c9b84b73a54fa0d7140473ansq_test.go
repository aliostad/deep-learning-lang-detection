package lnsq

import (
	"fmt"
	"sync"
	"testing"
)

func TestLocalNSQ_Dispatch(t *testing.T) {
	l := NewLocalNSQ()
	err := l.Dispatch("no_such_channel", 17)
	if err != ErrNoSuchChannel {
		t.Fatal("channel exist")
	}
}

func intCallbackWrap(wg *sync.WaitGroup, hint string) Callback {
	return func(v interface{}) {
		wg.Done()
		fmt.Printf("%s: %d\n", hint, v.(int))
	}
}

func TestLocalNSQ(t *testing.T) {
	l := NewLocalNSQ()
	var wg sync.WaitGroup
	wg.Add(1)
	l.Subscribe("channel", "topic", intCallbackWrap(&wg, "callback"), 1, 1)
	l.Dispatch("channel", 17)
	wg.Wait()
}

func TestLocalNSQ_DifferentChannel(t *testing.T) {
	l := NewLocalNSQ()
	var wg sync.WaitGroup
	wg.Add(2)
	l.Subscribe("channel1", "topic", intCallbackWrap(&wg, "callback1"), 1, 1)
	l.Subscribe("channel2", "topic", intCallbackWrap(&wg, "callback2"), 1, 1)
	l.Dispatch("channel1", 17)
	l.Dispatch("channel2", 18)
	wg.Wait()
}

func TestLocalNSQ_DifferentTopic(t *testing.T) {
	l := NewLocalNSQ()
	var wg sync.WaitGroup
	wg.Add(4)
	l.Subscribe("channel", "topic1", intCallbackWrap(&wg, "callback1"), 1, 1)
	l.Subscribe("channel", "topic2", intCallbackWrap(&wg, "callback2"), 1, 1)
	l.Dispatch("channel", 17)
	l.Dispatch("channel", 18)
	wg.Wait()
}

func BenchmarkLocalNSQ_Dispatch_DifferentChannel(b *testing.B) {
	b.StopTimer()
	l := NewLocalNSQ()
	var wg sync.WaitGroup
	wg.Add(2 * b.N)
	l.Subscribe("channel1", "topic", intCallbackWrap(&wg, "callback1"), 1, 2)
	l.Subscribe("channel2", "topic", intCallbackWrap(&wg, "callback2"), 1, 2)

	b.StartTimer()
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			l.Dispatch("channel1", 17)
			l.Dispatch("channel2", 18)
		}
	})

	wg.Wait()
	b.Logf("%#v\n", l.ChannelsStats())
	b.Logf("%#v\n", l.TopicsStats("channel1"))
	b.Logf("%#v\n", l.CallbacksStats("channel1","topic"))
}

func BenchmarkLocalNSQ_Dispatch_DifferentTopic(b *testing.B) {
	b.StopTimer()
	l := NewLocalNSQ()
	var wg sync.WaitGroup
	wg.Add(2 * b.N)
	l.Subscribe("channel", "topic1", intCallbackWrap(&wg, "callback1"), 1, 3)
	l.Subscribe("channel", "topic2", intCallbackWrap(&wg, "callback2"), 1, 3)

	b.StartTimer()
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			l.Dispatch("channel", 19)
		}
	})

	wg.Wait()
	b.Logf("%#v\n", l.ChannelsStats())
	b.Logf("%#v\n", l.TopicsStats("channel"))
	b.Logf("%#v\n", l.CallbacksStats("channel", "topic1"))
	b.Logf("%#v\n", l.CallbacksStats("channel", "topic2"))
}
