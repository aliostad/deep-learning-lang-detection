package worker

// Dispatcher struct
type Dispatcher struct {
	workerPool chan chan LogEvent
	maxWorkers int
	eventQueue chan LogEvent
}

// NewDispatcher creates dispatcher
func NewDispatcher(eventQueue chan LogEvent, maxWorkers int) *Dispatcher {
	workerPool := make(chan chan LogEvent, maxWorkers)

	return &Dispatcher{
		eventQueue: eventQueue,
		maxWorkers: maxWorkers,
		workerPool: workerPool,
	}
}

// Run creates and starts workers and strat to dispatch events from the eventQueue
func (d *Dispatcher) Run() {
	for i := 0; i < d.maxWorkers; i++ {
		worker := NewWorker(d.workerPool)
		worker.Start()
	}

	go d.dispatch()
}

func (d *Dispatcher) dispatch() {
	for {
		select {
		case event := <-d.eventQueue:
			go func() {
				workerEventQueue := <-d.workerPool
				workerEventQueue <- event
			}()
		}
	}
}
