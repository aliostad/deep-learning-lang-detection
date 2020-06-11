package tpool

type Dispatcher struct {
	maxWorkers int
	WorkerPool chan chan Job
}

func NewDispatcher(maxWorkers int) *Dispatcher {
	workerPool := make(chan chan Job, maxWorkers)
	return &Dispatcher{
		WorkerPool: workerPool,
		maxWorkers: maxWorkers,
	}
}

func (d *Dispatcher) Run() {
	for i := 0; i < d.maxWorkers; i++ {
		worker := NewWorker(d.WorkerPool)
		// start worker
		worker.Start()

		// to do, get same signal, stop worker
		// some case, stop worker: worker.Stop()
	}
	//监控
	go d.dispatch()

}

func (d *Dispatcher) dispatch() {
	for {
		select {
		case job := <-JobQueue:
			// dispatch get some job, give to worker
			go func(job Job) {
				// get a worker
				jobChannel := <-d.WorkerPool

				// give the work to worker
				jobChannel <- job

			}(job)
		}

	}
}
