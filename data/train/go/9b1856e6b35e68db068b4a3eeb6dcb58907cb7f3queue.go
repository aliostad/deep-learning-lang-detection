package chanqueue

import (
	"fmt"
)

type Job interface {
    Start() 
    Stop() 
    Wait()
}

type Queue struct {
	// Input channel queue of jobs
	Queue chan Job
	// Input dispatcher
	WorkDispatch *Dispatcher
	// MaxQueue entries
	MaxQueue int
	// Quit channel
	Quit chan bool
}

func NewQueue(maxQueue int, maxWorkers int) *Queue {
	q := make(chan Job, maxQueue)
	return &Queue{
		Queue: q, 
		WorkDispatch: NewDispatcher(q, maxWorkers), 
		MaxQueue: maxQueue,
		Quit: make(chan bool)}
}

// Start queue to listen for jobs
func (q *Queue) Start() {
    fmt.Printf("Starting queue of %d entries\n", q.MaxQueue)
	q.WorkDispatch.Start()
}

// Stop signals the worker to stop listening for work requests.
func (q *Queue) Stop() {
	q.WorkDispatch.Stop()
	go func(q *Queue) {
		q.Quit <- true
	}(q)
}

// Enqueue a job to be executed by a worker
func (q *Queue) EnqueueJob(j Job) {
	//fmt.Printf("Enqueueing job: %s - %s - %s\n", j.Reader.Method, j.Reader.URL.Host, j.Reader.URL.Path)
	q.Queue <- j
}
