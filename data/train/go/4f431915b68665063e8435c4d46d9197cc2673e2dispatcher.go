package workerpool

import (
	"runtime"
)

var maxWorkers = runtime.GOMAXPROCS(runtime.NumCPU() * 2)

type Dispatcher struct {
	// A pool of worker channels.
	WorkerPool chan chan Job
}

func NewDispatcher() *Dispatcher {
	pool := make(chan chan Job, maxWorkers)
	return &Dispatcher{WorkerPool: pool}
}

func (d *Dispatcher) Run() {
	// starting n number of workers.
	for i := 0; i < maxWorkers; i++ {
		worker := NewWorker(d.WorkerPool)
		worker.Start()
	}

	go d.dispatch()
}

func (d *Dispatcher) dispatch() {
	for {
		select {
		case job := <-JobQueue:
			// a job request has been received.
			go func(job Job) {
				// try to obtain a worker job channel that is available.
				// this will block until a worker is idle.
				jobChannel := <-d.WorkerPool

				// dispatch the job to the worker channel.
				jobChannel <- job
			}(job)
		}
	}
}
