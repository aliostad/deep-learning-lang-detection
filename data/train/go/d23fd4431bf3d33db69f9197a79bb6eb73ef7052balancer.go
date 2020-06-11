package loadbalancer

import (
	"container/heap"
	"fmt"
)

type Balancer struct {
	pool Pool
	done chan *Worker
}

func NewBalancer(pool Pool, done chan *Worker) *Balancer {
	return &Balancer{pool: pool, done: done}
}

func (b *Balancer) Balance(work chan Request) {
	for {
		select {
		case req := <-work:
			b.dispatch(req)
		case w := <-b.done:
			b.completed(w)
		}
	}
}

func (b *Balancer) dispatch(req Request) {
	fmt.Printf("dispatch request->%v\n", req)
	w := heap.Pop(&b.pool).(*Worker)
	w.requests <- req
	w.pending++
	heap.Push(&b.pool, w)
	fmt.Printf("end dispatch request->%v\n", req)
}

func (b *Balancer) completed(w *Worker) {
	fmt.Println("completed worker", w.index)
	w.pending--
	fmt.Printf("pool length is %d\n", len(b.pool))
	heap.Remove(&b.pool, w.index)
	heap.Push(&b.pool, w)
	fmt.Println("done completed worker", w.index)
}
