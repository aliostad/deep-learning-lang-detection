package rumo

import (
	"errors"
	"reflect"
	"strconv"
	"sync"

	"github.com/mattn/anko/vm"
)

type Process struct {
	sync.WaitGroup
	app *App
	env *vm.Env

	// mutex values
	mutex sync.RWMutex
	pid   uint32
	done  bool
	ret   *reflect.Value
	err   error
}

func (process *Process) Kill() {
	vm.Interrupt(process.env)
}

func (man *Manager) Run(app *App, appendix string) *Process {
	process := &Process{}
	process.app = app
	process.env = vm.NewEnv()

	// set environment variables
	for key, value := range man.env {
		process.env.Define(key, value)
	}

	// initialize env
	loadCore(process.env)
	man.loadOutput(process.env)
	man.loadImport(process.env)

	// mutex values
	man.attach(process) // pid = i...
	process.done = false
	process.ret = nil
	process.err = nil

	// start process in new routine
	process.Add(1)
	go func() {
		ret, err := vm.Run(process.app.stmts, process.env)

		// run appendix (for commands)
		if err == nil && len(appendix) > 0 {
			ret, err = process.env.Execute(appendix)
		}

		// extend error with line and col
		if err != nil {
			switch v := err.(type) {
			case *vm.Error:
				// TODO: pull request to fix line num error
				err = errors.New(v.Error() + " (line:" + strconv.Itoa((v.Pos.Line+1)/2) + " col:" + strconv.Itoa(v.Pos.Column) + ")")
			}
		}

		// mutex values
		process.mutex.Lock()
		man.detach(process) // pid = 0
		process.done = true
		process.ret = &ret
		process.err = err
		process.env.Destroy()
		process.mutex.Unlock()

		// Wait() == done
		process.Done()
	}()
	return process
}

func (process *Process) IsDone() bool {
	process.mutex.RLock()
	defer process.mutex.RUnlock()
	return process.done
}

func (process *Process) GetError() error {
	process.mutex.RLock()
	defer process.mutex.RUnlock()
	return process.err
}

func (process *Process) GetReturn() *reflect.Value {
	process.mutex.RLock()
	defer process.mutex.RUnlock()
	return process.ret
}
