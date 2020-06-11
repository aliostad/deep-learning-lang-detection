package dispatcher

import (
	"fmt"
	"github.com/cooladdr/millionps/worker"
)

//
//
type Dispatcher struct {
	WorkerPool chan worker.Worker
	JobQueue   chan worker.Job
	MaxWorkers int
}

//
//
func NewDispatcher(maxWorkers int) *Dispatcher {
	worker_pool := make(chan worker.Worker, maxWorkers)
	return &Dispatcher{WorkerPool: worker_pool, JobQueue: worker.JobQueue, MaxWorkers: maxWorkers}
}

//
//
func (d *Dispatcher) Run() {
	for i := 0; i < d.MaxWorkers; i++ {
		worker := worker.NewWorker(d.WorkerPool)
		worker.Start()
	}

	go d.dispatch()
}

//
//
func (d *Dispatcher) dispatch() {
	fmt.Println("start dispatch")
	for {
		select {
		case job := <-d.JobQueue:

			//For quickly dispatch a job, it is better to
			//start a routine to queue the job to an available worker
			go func(job worker.Job) {
				worker := <-d.WorkerPool
				worker.JobChannel <- job
			}(job)

		}
	}
	fmt.Println("dispatch exit")
}
