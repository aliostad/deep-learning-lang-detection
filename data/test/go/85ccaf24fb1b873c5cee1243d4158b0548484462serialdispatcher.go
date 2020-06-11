package command

import "sync"

// NewSerialDispatcher creates a new PrallelDispatcher with the given handlers
func NewSerialDispatcher(handlers []Handler) Dispatcher {
	return &SerialDispatcher{
		handlers: handlers,
		mutex:    sync.RWMutex{},
	}
}

// SerialDispatcher is a command dispatcher wich will run all handlers in
// parallel and wait all handlers to finish before returning.
//
// If any handler returns an error the dispatcher will stop execution and will
// return that error.
//
// This dispatcher is *thread safe*.
type SerialDispatcher struct {
	handlers []Handler
	mutex    sync.RWMutex
}

// AppendHandlers implements `Dispatcher.AppendHandlers`
func (d *SerialDispatcher) AppendHandlers(handlers ...Handler) {
	d.mutex.Lock()
	defer d.mutex.Unlock()

Loop:
	for _, newHandler := range handlers {
		for _, existingHandler := range d.handlers {
			if newHandler == existingHandler {
				continue Loop
			}
		}
		d.handlers = append(d.handlers, newHandler)
	}
}

// Dispatch implements `Dispatcher.Dispatch`
func (d *SerialDispatcher) Dispatch(cmd interface{}) (err error) {
	d.mutex.RLock()
	defer d.mutex.RUnlock()

	defer func() {
		if e := recover(); e != nil {
			err = e.(error)
		}
	}()

	found := false
	for _, handler := range d.handlers {
		if handler == nil {
			continue
		}
		if !handler.CanHandle(cmd) {
			continue
		}
		found = true
		if err = handler.Handle(cmd, d); err != nil {
			return
		}
	}

	if !found {
		return &NoHandlerFoundError{
			Command: cmd,
		}
	}

	return
}

// DispatchOptional implements `Dispatcher.DispatchOptional`
func (d *SerialDispatcher) DispatchOptional(cmd interface{}) (err error) {
	d.mutex.RLock()
	defer d.mutex.RUnlock()

	err = d.Dispatch(cmd)
	switch err.(type) {
	case *NoHandlerFoundError:
		return nil
	default:
		return err
	}
}
