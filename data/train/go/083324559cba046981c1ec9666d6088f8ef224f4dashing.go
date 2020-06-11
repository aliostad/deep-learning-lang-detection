package dashing

//Copied and modified from https://github.com/gigablah/dashing-go

import "path/filepath"

// Dashing struct definition.
type Dashing struct {
	started bool
	broker  *broker
	worker  *worker
	server  *server
}

// Start actives the broker, workers and the server.
func (d *Dashing) Start() error {
	if !d.started {
		d.broker.start()
		d.worker.start()
		d.started = true
		return d.server.start()
	}
	return nil
}

// Register will register jobs in the worker
func (d *Dashing) Register(jobs ...Job) {
	d.worker.register(jobs...)
}

// NewDashing sets up the event broker, workers and webservice.
func NewDashing(webroot, dashingJSRoot, defaultDashboard, authToken, host, port string, dev bool) (*Dashing, error) {
	broker := newBroker()
	worker := newWorker(broker)
	if webroot != "" {
		webroot = filepath.Clean(webroot) + "/"
	}
	server, err := newServer(broker, webroot, dashingJSRoot, defaultDashboard, authToken, host, port)
	if err != nil {
		return nil, err
	}
	server.dev = dev

	return &Dashing{
		started: false,
		broker:  broker,
		worker:  worker,
		server:  server,
	}, nil
}
