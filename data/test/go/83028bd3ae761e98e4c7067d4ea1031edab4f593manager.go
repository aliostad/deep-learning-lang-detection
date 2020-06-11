/*
	Copyright (c) 2011 Ross Light.
	Copyright (c) 2005 Mathias Wein, Alejandro Conty, and Alfredo de Greef.

	This file is part of goray.

	goray is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	goray is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with goray.  If not, see <http://www.gnu.org/licenses/>.
*/

package job

import (
	"errors"
	"fmt"
	"io"
	"sync"

	"zombiezen.com/go/goray/internal/yamlscene"
)

// Manager maintains a render job queue and records completed jobs.
type Manager struct {
	Storage  Storage
	jobs     map[string]*Job
	jobQueue chan *Job
	nextNum  int
	lock     sync.RWMutex
}

// NewManager creates a new, initialized job manager.
func NewManager(storage Storage, queueSize int) (manager *Manager) {
	manager = &Manager{Storage: storage}
	manager.Init(queueSize)
	return
}

// Init initializes the manager.  This function is called automatically by
// NewJobManager.
func (manager *Manager) Init(queueSize int) {
	manager.lock.Lock()
	defer manager.lock.Unlock()

	if manager.jobQueue != nil {
		close(manager.jobQueue)
	}
	manager.jobs = make(map[string]*Job)
	manager.jobQueue = make(chan *Job, queueSize)
	manager.nextNum = 0
}

// New creates a new job and adds it to the job queue.
func (manager *Manager) New(yaml io.Reader, params yamlscene.Params) (j *Job, err error) {
	manager.lock.Lock()
	defer manager.lock.Unlock()
	name := fmt.Sprintf("%04d", manager.nextNum)
	j = New(name, yaml, params)
	select {
	case manager.jobQueue <- j:
		manager.jobs[name] = j
		manager.nextNum++
	default:
		err = errors.New("Job queue is full")
	}
	return
}

// Get returns a job with the given name.
func (manager *Manager) Get(name string) (j *Job, ok bool) {
	manager.lock.RLock()
	defer manager.lock.RUnlock()
	j, ok = manager.jobs[name]
	return
}

func (manager *Manager) List() (jobs []*Job) {
	manager.lock.RLock()
	defer manager.lock.RUnlock()
	jobs = make([]*Job, 0, len(manager.jobs))
	for _, j := range manager.jobs {
		jobs = append(jobs, j)
	}
	return
}

// Stop causes the manager to stop accepting new jobs.
func (manager *Manager) Stop() {
	close(manager.jobQueue)
}

// RenderJobs renders jobs in the queue until Stop is called.
func (manager *Manager) RenderJobs() {
	for job := range manager.jobQueue {
		w, err := manager.Storage.OpenWriter(job)
		if err == nil {
			job.Render(w)
			w.Close()
		} else {
			job.ChangeStatus(Status{Code: StatusError, Error: err})
		}
	}
}
