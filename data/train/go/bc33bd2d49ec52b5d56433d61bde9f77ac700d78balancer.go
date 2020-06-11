package main

import (
	"container/heap"
	"fmt"
)

// Balancer has a pool of workers and a channel to pass
// workers through when they are finished a task
type Balancer struct {
	pool *Pool
	done chan *Worker
}

// Balance takes in a channel of requests and distrubutes them
func (b *Balancer) Balance(requests <-chan Request) {
	for {
		select {
		case request := <-requests:
			b.dispatch(request)
			fmt.Println(b.pool)
		case worker := <-b.done:
			b.complete(worker)
		}
	}
}

// dispatch distrubutes the requests
func (b *Balancer) dispatch(request Request) {
	w := heap.Pop(b.pool).(*Worker)
	w.requests <- request
	w.pending += 1
	heap.Push(b.pool, w)
}

// complete updates the worker pool when a request is complete
func (b Balancer) complete(worker *Worker) {
	worker.pending -= 1
	heap.Fix(b.pool, worker.index)
}
