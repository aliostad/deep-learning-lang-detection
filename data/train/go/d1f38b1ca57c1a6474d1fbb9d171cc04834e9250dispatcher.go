package simplepool

// Dispatcher is a object which sends job to the worker which is free to work.
type Dispatcher struct {
	pool  chan *Worker
	queue chan Job
	stop  chan bool
}

// dispatch is method which will fetch a job and dispatch it to first available worker.
func (d *Dispatcher) dispatch() {
	for {
		select {
		case job := <-d.queue:
			worker := <-d.pool
			worker.channel <- job

		case stop := <-d.stop:
			if stop {
				for i := 0; i < cap(d.pool); i++ {
					worker := <-d.pool
					worker.stop <- true
					<-worker.stop
				}
				d.stop <- true
				return
			}
		}
	}
}

// newDispatcher is construction function for Dispatcher object.
func newDispatcher(p chan *Worker, q chan Job) *Dispatcher {
	d := &Dispatcher{
		pool:  p,
		queue: q,
		stop:  make(chan bool),
	}

	for i := 0; i < cap(d.pool); i++ {
		worker := newWorker(d.pool)
		worker.start()
	}

	go d.dispatch()
	return d
}
