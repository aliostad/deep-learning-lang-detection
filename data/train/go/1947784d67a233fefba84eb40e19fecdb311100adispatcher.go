package server

type Dispatcher struct {
	// Pool of worker channels that we can pass jobs through.
	WorkerPool chan chan Job
	numWorkers int
}

// Constructor for the dispatcher, takes in the desired
// number of workers to process jobs.
func NewDispatcher(numWorkers int) *Dispatcher {
	JobQueue = make(chan Job)
	workerPool := make(chan chan Job, numWorkers)
	return &Dispatcher{WorkerPool: workerPool, numWorkers: numWorkers}
}

// Start the dispatcher and initialize all workers.
func (d *Dispatcher) Start() {
	for i := 0; i < d.numWorkers; i++ {
		worker := NewWorker(d.WorkerPool)
		worker.Start()
	}
	go d.dispatch()
}

// Dispatch available jobs to worker job channels.
func (d *Dispatcher) dispatch() {
	for {
		select {
		case job := <-JobQueue:
			// We have a job request.
			go func(job Job) {
				// Attempt to fetch a worker job channel that is available.
				// Blocks until a worker is idle.
				jobChannel := <-d.WorkerPool
				// Dispatch job to worker job channel.
				jobChannel <- job
			}(job)
		}
	}
}
