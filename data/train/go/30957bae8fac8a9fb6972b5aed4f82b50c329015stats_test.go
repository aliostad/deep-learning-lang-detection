package stats

//Copyright 2016 MediaMath <http://www.mediamath.com>.  All rights reserved.
//Use of this source code is governed by a BSD-style
//license that can be found in the LICENSE file.

import (
	"testing"
	"time"

	"context"
)

func TestDatum(t *testing.T) {

	broker := StartBroker(100)
	broker.RegisterEndpoint(LogEndpoint())

	type counts struct {
		count  int
		gauge  int
		timing int
	}
	sum := make(chan *counts)

	broker.RegisterEndpoint(func(data <-chan interface{}) {
		received := 0
		c := &counts{}
		for datum := range data {
			switch t := datum.(type) {
			case *count:
				c.count += t.Value
			case *gauge:
				c.gauge += t.Value
			case *timing:
				c.timing += t.Value
			}

			received++
			if received >= 6 {
				break
			}
		}

		sum <- c
		close(sum)
	})

	broker.Count("C", 1)
	broker.Gauge("G", 3)
	broker.Timing("T", 3)
	broker.Count("C", 8)
	broker.Timing("T", 1)
	broker.Gauge("G", 3)

	ctx, clean := context.WithTimeout(context.Background(), time.Second)
	defer clean()

	err := broker.Finish(ctx)
	if err != nil {
		t.Fatal(err)
	}

	select {
	case c := <-sum:

		if c == nil {
			t.Fatal("No c")
		}

		if c.count != 9 || c.gauge != 6 || c.timing != 4 {
			t.Errorf("Wrong: %v", c)
		}
	case <-ctx.Done():
		t.Fatal(ctx.Err())
	}

}

func TestMultipleRegistered(t *testing.T) {

	broker := StartBroker(100)

	sum1 := make(chan int)
	broker.RegisterEndpoint(func(data1 <-chan interface{}) {
		s := 0
		for c := range data1 {
			t := c.(*count)
			s += t.Value

			if s >= 21 {
				break
			}
		}
		sum1 <- s
		close(sum1)
	})

	sum2 := make(chan int)
	broker.RegisterEndpoint(func(data2 <-chan interface{}) {
		s := 0
		for c := range data2 {
			t := c.(*count)
			s += t.Value

			if s >= 21 {
				break
			}
		}
		sum2 <- s
		close(sum2)
	})

	broker.Count("C", 7)
	broker.Count("C", 8)
	broker.Count("C", 6)

	ctx, clean := context.WithTimeout(context.Background(), 1*time.Second)
	defer clean()
	err := broker.Finish(ctx)
	if err != nil {
		t.Fatal(err)
	}

	select {
	case s := <-sum1:
		if s != 21 {
			t.Errorf("Wrong: %v", s)
		}
	case <-ctx.Done():
		t.Fatal(ctx.Err())
	}

	select {
	case s := <-sum2:
		if s != 21 {
			t.Errorf("Wrong: %v", s)
		}
	case <-ctx.Done():
		t.Fatal(ctx.Err())
	}
}
