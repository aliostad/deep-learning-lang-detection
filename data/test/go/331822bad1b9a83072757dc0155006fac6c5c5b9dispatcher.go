package main

type Dispatcher struct {
	WorkerPool chan chan Job
	MaxWorkers int
}

func NewDispatcher(workersCount int) *Dispatcher {
	pool := make(chan chan Job, workersCount)
	return &Dispatcher{
		WorkerPool: pool,
		MaxWorkers: workersCount,
	}
}

func (d *Dispatcher) Run() {
	for i := 0; i < d.MaxWorkers; i++ {
		worker := NewWorker(d.WorkerPool)
		worker.Start()
	}
	go d.dispatch()
}

func (d *Dispatcher) dispatch() {
	for {
		select {
		case job := <-JobQueue:
			go func(job Job) {
				jobChannel := <-d.WorkerPool
				jobChannel <- job
			}(job)
		}
	}
}
