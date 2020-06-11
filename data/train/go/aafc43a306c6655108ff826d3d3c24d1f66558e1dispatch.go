/*
Copyright 2016 Under Armour, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/*
 a simple implementation of a dispatcher

 all one needs to do is implement the IJob interface and

	type Job struct{
		to_work_on string
		thing_that_works *FancyObject
	}
	func (j *Job) DoWork(){
		j.thing_that_works(to_work_on)
	}

	workers := 10
	queue_depth := 100
 	jobQueue      := make(chan *Job, queue_depth)
 	disp_queue     := make(chan chan *Job, workers)
	job_dispatcher := NewDispatch(workers, disp_queue, jobQueue)
	job_dispatcher.Run()

	jobQueue <- &Job{to_work_on: "frank", thing_that_works: MyDoDad}

*/

package dispatch

import (
	"cadent/server/stats"
	"cadent/server/utils"
	"github.com/cenkalti/backoff"
	logging "gopkg.in/op/go-logging.v1"
	"time"
)

type Worker struct {
	workerPool chan chan IJob
	jobChannel chan IJob
	quit       chan bool
	idx        int
	dispatcher IDispatcher
	log        *logging.Logger
}

func NewWorker(workerPool chan chan IJob, dispatcher IDispatcher) *Worker {

	return &Worker{
		workerPool: workerPool,
		jobChannel: make(chan IJob),
		quit:       make(chan bool),
		dispatcher: dispatcher,
		log:        logging.MustGetLogger("dispatch.worker"),
	}
}

func (w *Worker) backOffConf() *backoff.ExponentialBackOff {
	back := backoff.NewExponentialBackOff()
	back.InitialInterval = time.Second
	back.MaxInterval = 10 * time.Second
	back.MaxElapsedTime = 60 * time.Second
	return back

}

func (w *Worker) Workpool() chan chan IJob {
	return w.workerPool
}
func (w *Worker) Jobs() chan IJob {
	return w.jobChannel
}

func (w *Worker) Shutdown() chan bool {
	return w.quit
}

// starts the run loop for the worker, listening for a quit channel in
// case we need to stop it
func (w *Worker) Start() {

	retryNotice := func(err error, after time.Duration) {
		stats.StatsdClientSlow.Incr("dispatch.retry", 1)
		w.log.Error("Retrying :: Workfailed :: %v : after %v", err, after)
	}

	go func() {
		for {
			// register the current worker into the worker queue.
			w.Workpool() <- w.Jobs()

			select {
			case <-w.Shutdown():
				return
			case job, more := <-w.Jobs():
				if !more || job == nil {
					return
				}
				err := backoff.RetryNotify(job.DoWork, w.backOffConf(), retryNotice)
				// requeue hopefully things are idempotent
				if err != nil {
					w.log.Error("Workfailed Backoff retries: %v re adding to queue", err)
					w.dispatcher.JobsQueue() <- job
				}
			}
		}
	}()
}

// Stop signals the worker to stop listening for work requests.
func (w *Worker) Stop() {
	w.Shutdown() <- true
}

/************* DISPATCH ********/

type Dispatch struct {
	workPool   chan chan IJob
	jobQueue   chan IJob
	shutdown   chan bool
	errorQueue chan error
	workers    []*Worker
	numworkers int
	retries    int
	Name       string
}

func NewDispatch(numworkers int, workPool chan chan IJob, jobQueue chan IJob) *Dispatch {
	dis := &Dispatch{
		workPool:   workPool,
		numworkers: numworkers,
		jobQueue:   jobQueue,
		errorQueue: make(chan error),
		workers:    make([]*Worker, numworkers, numworkers),
		shutdown:   make(chan bool),
		retries:    0,
	}
	return dis
}

func (d *Dispatch) Retries() int {
	return d.retries
}

func (d *Dispatch) SetRetries(r int) {
	d.retries = r
}

func (d *Dispatch) Workpool() chan chan IJob {
	return d.workPool
}

func (d *Dispatch) JobsQueue() chan IJob {
	return d.jobQueue
}

func (d *Dispatch) ErrorQueue() chan error {
	return d.errorQueue
}

func (d *Dispatch) Run() error {
	// starting n number of workers
	for i := 0; i < d.numworkers; i++ {
		worker := NewWorker(d.workPool, d)
		worker.idx = i
		d.workers[i] = worker
		worker.Start()
	}

	go d.dispatch()
	return nil
}

func (d *Dispatch) BackgroundRun() error {
	// starting n number of workers
	for i := 0; i < d.numworkers; i++ {
		worker := NewWorker(d.workPool, d)
		d.workers[i] = worker
		worker.Start()
	}

	go d.backgroundDispatch()
	return nil
}

func (d *Dispatch) Shutdown() {
	d.shutdown <- true
}

func (d *Dispatch) dispatch() {
	for {
		select {
		case job := <-d.JobsQueue():
			// a job request has been received
			// try to obtain a worker job channel that is available.
			// this will block until a worker is idle
			jobChannel := <-d.Workpool()

			// dispatch the job to the worker job channel
			jobChannel <- job
		case <-d.shutdown:
			//close(d.JobsQueue())
			for _, w := range d.workers {
				w.Stop()
			}
			//close(d.Workpool())
			return
		}
	}
}

func (d *Dispatch) backgroundDispatch() {
	for {
		select {
		case job := <-d.JobsQueue():
			// a job request has been received
			go func(job IJob) {
				// try to obtain a worker job channel that is available.
				// this will block until a worker is idle
				jobChannel := <-d.Workpool()

				// dispatch the job to the worker job channel
				jobChannel <- job
				return
			}(job)
		case <-d.shutdown:
			for _, w := range d.workers {
				w.Shutdown() <- true
			}
			close(d.JobsQueue())
			close(d.Workpool())
			return
		}
	}
}

/** Put all the pieces together */
type DispatchQueue struct {
	Name          string
	jobQueue      chan IJob
	dispatchQueue chan chan IJob
	dispatcher    *Dispatch
	addTimeOut    *time.Timer
	startstop     utils.StartStop
}

func NewDispatchQueue(workers int, maxQueueLength int, retries int) *DispatchQueue {
	dp := new(DispatchQueue)
	dp.jobQueue = make(chan IJob, maxQueueLength)
	dp.dispatchQueue = make(chan chan IJob, workers)
	dp.dispatcher = NewDispatch(workers, dp.dispatchQueue, dp.jobQueue)
	dp.dispatcher.SetRetries(retries)
	dp.addTimeOut = time.NewTimer(10 * time.Second)
	return dp
}

func (dp *DispatchQueue) Start() {
	dp.startstop.Start(func() {
		dp.dispatcher.Run()
	})
}

func (dp *DispatchQueue) Stop() {
	dp.startstop.Stop(func() {
		dp.dispatcher.Shutdown()
	})
}

func (dp *DispatchQueue) Add(job IJob) {
	dp.jobQueue <- job
}

func (dp *DispatchQueue) Len() int {
	return len(dp.jobQueue)
}
