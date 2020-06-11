package util

const (
	// ProcessQueueMaxRetries is the maximum times a process queue item will be retried before being dropped.
	ProcessQueueMaxRetries = 10
)

// static vars
var (
	workerQueue  chan processQueueWorker
	processQueue = make(chan processQueueEntry, 1024) //buffered work channel. 1024 better be enough
)

// ProcessQueueAction is an action that can be dispatched by the process queue.
type ProcessQueueAction func(value interface{}) error

// QueueWorkItem adds a work item to the process queue.
func QueueWorkItem(action ProcessQueueAction, value interface{}) {
	processQueue <- processQueueEntry{Action: action, Value: value}
}

// StartProcessQueueDispatchers starts the dispatcher workers for the process quere.
func StartProcessQueueDispatchers(numWorkers int) {
	workerQueue = make(chan processQueueWorker, numWorkers)

	for id := 0; id < numWorkers; id++ {
		worker := newProcessQueueWorker(id, workerQueue)
		worker.Start()
	}

	go func() {
		for {
			select {
			case work := <-processQueue:
				go func() {
					worker := <-workerQueue
					worker.Work <- work
				}()
			}
		}
	}()
}

type processQueueEntry struct {
	Action ProcessQueueAction
	Value  interface{}
	Tries  int
}

type processQueueWorker struct {
	ID          int
	Work        chan processQueueEntry
	WorkerQueue chan processQueueWorker
	QuitChan    chan bool
}

func (pqw processQueueWorker) Start() {
	go func() {
		for {
			pqw.WorkerQueue <- pqw
			select {
			case work := <-pqw.Work:
				workErr := work.Action(work.Value)
				if workErr != nil {
					work.Tries = work.Tries + 1
					if work.Tries < ProcessQueueMaxRetries {
						processQueue <- work
					}
				}
			case <-pqw.QuitChan:
				return
			}
		}
	}()
}

func (pqw processQueueWorker) Stop() {
	go func() {
		pqw.QuitChan <- true
	}()
}

func newProcessQueueWorker(id int, workerQueue chan processQueueWorker) processQueueWorker {
	worker := processQueueWorker{
		ID:          id,
		Work:        make(chan processQueueEntry),
		WorkerQueue: workerQueue,
		QuitChan:    make(chan bool),
	}
	return worker
}
