package worker

import (
	"sync"
	"time"

	log "github.com/opsee/logrus"
	"github.com/cenkalti/backoff"
	"github.com/grepory/scheduler"
	"github.com/opsee/gmunch"
)

type Dispatch map[string]DispatchFunc
type DispatchFunc func(*gmunch.Event) []Task

type Task interface {
	scheduler.Task
}

type Consumer interface {
	Start() error
	Stop()
	Events() chan *gmunch.Event
}

type Config struct {
	Dispatch Dispatch
	Consumer Consumer
	MaxJobs  uint
}

type Worker struct {
	dispatch    Dispatch
	consumer    Consumer
	scheduler   *scheduler.Scheduler
	dispatchMut sync.Mutex
	stopChan    chan struct{}
	stoppedChan chan struct{}
	stopping    bool
	logger      *log.Entry
}

func New(config Config) *Worker {
	logger := log.WithField("worker", "worker")

	if config.MaxJobs == 0 {
		config.MaxJobs = 4
		logger.Warn("MaxJobs not set, defaulting to 4")
	}

	return &Worker{
		dispatch:    config.Dispatch,
		consumer:    config.Consumer,
		scheduler:   scheduler.NewScheduler(config.MaxJobs),
		stopChan:    make(chan struct{}, 1),
		stoppedChan: make(chan struct{}, 1),
		logger:      logger,
	}
}

func (w *Worker) Start() error {
	w.logger.Info("starting")

	errChan := make(chan error)
	go func() {
		errChan <- w.consumer.Start()
	}()

	var err error

	for {
		select {
		case event, ok := <-w.consumer.Events():
			if !ok {
				// the consumer channel has been closed, shutdown
				return nil
			}

			w.logger.Debugf("got event from consumer: %s", event.Name)

			err = w.DispatchEvent(event)
			if err != nil {
				// we've tried too long to submit our tasks to the queue,
				// so let's just shut down
				return err
			}

		case err = <-errChan:
			return err
		}
	}

	w.stoppedChan <- struct{}{}
	return nil
}

func (w *Worker) DispatchEvent(event *gmunch.Event) error {
	dispatchFunc, err := w.getDispatch(event)
	if err != nil {
		// just log and ignore
		w.logger.WithError(err).Error("no dispatch function for event: ", event.Name)
		return nil
	}

	return w.trySubmit(dispatchFunc(event))
}

func (w *Worker) Stop() {
	w.logger.Info("stopping")
	w.consumer.Stop()

	defer close(w.stopChan)
	defer close(w.stoppedChan)

	w.stopChan <- struct{}{}
	select {
	case <-w.stoppedChan:
	case <-time.After(5 * time.Second):
	}
	w.logger.Info("stopped")
}

func (w *Worker) shouldStop() bool {
	if w.stopping {
		return true
	}

	select {
	case <-w.stopChan:
		w.stopping = true
		return w.stopping
	default:
		return false
	}
}

// here's where we have to manage the backpressure
func (w *Worker) trySubmit(tasks []Task) error {
	var (
		err error
	)

	backoff.Retry(func() error {
		if w.shouldStop() {
			return nil
		}

		numTasks := w.scheduler.QueueDepth() + len(tasks)
		w.logger.Debugf("queue depth: %d max queue depth: %d", numTasks, w.scheduler.MaxQueueDepth)

		if uint(numTasks) > w.scheduler.MaxQueueDepth {
			w.logger.Error("max queue depth reached")

			// take a breather for the queue to clear so that we can
			// ensure all of are tasks for one event are submitted together
			return errMaxQueueDepth
		}

		for _, task := range tasks {
			w.logger.Debugf("submitting task: %#v", task)

			_, err = w.scheduler.Submit(task)
			if err != nil {
				w.logger.WithError(err).Error("scheduler submit error")

				// how this would happen, nobody can possibly know
				// is someone stealing our queue????
				return err
			}
		}

		return nil

	}, &backoff.ExponentialBackOff{
		InitialInterval:     100 * time.Millisecond,
		RandomizationFactor: 0.5,
		Multiplier:          1.5,
		MaxInterval:         1 * time.Minute,
		MaxElapsedTime:      60 * time.Minute,
		Clock:               &systemClock{},
	})

	return err
}

func (w *Worker) getDispatch(event *gmunch.Event) (DispatchFunc, error) {
	w.dispatchMut.Lock()
	defer w.dispatchMut.Unlock()

	if dispatchFunc, ok := w.dispatch[event.Name]; ok {
		return dispatchFunc, nil
	}

	return nil, errNoDispatch
}

type systemClock struct{}

func (s *systemClock) Now() time.Time {
	return time.Now()
}
