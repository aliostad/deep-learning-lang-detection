package dispatch

import "sync"

type Dispatch struct {
	GlobalQueue Queue
	qlist       map[string]Queue
	mutex       sync.Mutex
}

func NewDispatch() *Dispatch {
	dispatch := &Dispatch{
		GlobalQueue: Queue{
			queue: make(chan func(), 128),
			close: make(chan bool, 1),
			size:  16,
		},
		qlist: make(map[string]Queue),
		mutex: sync.Mutex{},
	}

	dispatch.Start()
	return dispatch
}

func (d *Dispatch) Start() {
	d.mutex.Lock()
	defer d.mutex.Unlock()

	d.GlobalQueue.Start()
	for k := range d.qlist {
		q := d.qlist[k]
		q.Start()
	}
}

func (d *Dispatch) Close() {
	d.mutex.Lock()
	defer d.mutex.Unlock()

	d.GlobalQueue.Stop()
	for k := range d.qlist {
		q := d.qlist[k]
		q.Stop()
	}
}

func (d *Dispatch) NewQueue(name string, c *Config) *Queue {
	d.mutex.Lock()
	defer d.mutex.Unlock()

	q, ok := d.qlist[name]
	if ok {
		return &q
	}

	q = Queue{
		queue: make(chan func(), c.Backoff),
		close: make(chan bool, 1),
		size:  c.Size,
	}
	d.qlist[name] = q
	q.Start()
	return &q
}

func (d *Dispatch) Queue(name string) *Queue {
	d.mutex.Lock()
	defer d.mutex.Unlock()

	q, ok := d.qlist[name]
	if ok {
		return &q
	}
	return nil

}
