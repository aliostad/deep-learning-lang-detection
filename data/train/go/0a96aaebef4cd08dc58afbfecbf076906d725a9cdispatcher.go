package quest

import (
	//"errors"
	"fmt"
	"time"
)

var Dispatch *Dispatcher

type Dispatcher struct {
	WorkerQueue chan chan WorkRequest
	WorkQueue   chan WorkRequest
	Workers     map[int]*Worker
	QuitChan    chan bool
}

func NewDispatcher(nworkers int) error {

	if Dispatch != nil {
		//TODO: More errs handling here
		//return errors.New("Dispatcher is already runned!")
	}

	Dispatch = &Dispatcher{
		// First, initialize the channel we are going to but the workers' work channels into.
		WorkerQueue: make(chan chan WorkRequest, nworkers),
		WorkQueue:   make(chan WorkRequest, 100),
		Workers:     make(map[int]*Worker),
		QuitChan:    make(chan bool),
	}

	// Now, create all of our workers.
	for i := 0; i < nworkers; i++ {
		fmt.Printf("Worker%d starting \r", i+1)
		worker := NewWorker(i+1, Dispatch.WorkerQueue)
		Dispatch.Workers[i+1] = worker
	}

	Dispatch.Start()
	return nil
}

func (d *Dispatcher) Start() {
	go func() {
		for {

			select {
			case work := <-d.WorkQueue:
				fmt.Println("Received work requeust")
				go func() {
					worker := <-d.WorkerQueue
					fmt.Println("Dispatching work request")
					worker <- work
				}()
			case <-d.QuitChan:
				// We have been asked to stop.
				for _, worker := range d.Workers {
					worker.Stop()
				}
				fmt.Println("Dispatching stoped")
				return
			case <-time.After(5 * time.Second):
				fmt.Printf("Dispatching of %v workers \n", len(d.Workers))

			}
		}
	}()
}

func (d *Dispatcher) Stop() {
	go func() {
		d.QuitChan <- true
	}()
}
