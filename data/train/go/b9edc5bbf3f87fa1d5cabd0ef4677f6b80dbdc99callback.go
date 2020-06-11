// Package callback provides a mechanism for registering and dispatching
// arbitrary callbacks.
package callback

import (
	"container/list"
	"reflect"
	"sync"
	"sync/atomic"
)

type CallbackIdentifier struct {
	name  string
	ident uint64
}

var lastIdentifier uint64

// Various dispatch behaviors
const (
	// Call handlers synchronously on the current goroutine
	DispatchSerial = iota
	// Call each handler on its own goroutine
	DispatchParallel
	// Call each handler on its own goroutine, but wait until all handlers
	// have finished before returning.
	DispatchParallelAndWait
)

// A Registry keeps track of registered callbacks. Callbacks registered with
// one Registry will not fire when another Registry is dispatched.
type Registry struct {
	lock        sync.Mutex
	copyOnWrite map[string]bool
	callbacks   map[string]*list.List
	dispatch    func(*list.List, ...interface{})
}

type callbackElt struct {
	Ident uint64
	Func  interface{}
}

var dispatchers = map[int]func(*list.List, ...interface{}){
	DispatchSerial:          dispatchSerial,
	DispatchParallel:        dispatchParallel,
	DispatchParallelAndWait: dispatchParallelAndWait,
}

// NewRegistry returns a new *Registry.
// The passed behavior must be one of the Dispatch* behavior constants.
func NewRegistry(behavior int) *Registry {
	if dispatch, ok := dispatchers[behavior]; ok {
		return &Registry{
			copyOnWrite: make(map[string]bool),
			callbacks:   make(map[string]*list.List),
			dispatch:    dispatch,
		}
	} else {
		panic("unknown behavior")
	}
}

// AddCallback registers a callback function for a given name and returns an
// identifier that can be used to remove the callback later.
// The callback function is an interface{} but a runtime error will be thrown
// if it is not a func with no return values.
func (r *Registry) AddCallback(name string, f interface{}) CallbackIdentifier {
	validate(f)
	r.lock.Lock()
	defer r.lock.Unlock()
	if r.copyOnWrite[name] {
		r.copyHandlers(name)
	}
	handlers := r.callbacks[name]
	if handlers == nil {
		handlers = list.New()
		r.callbacks[name] = handlers
	}

	ident := atomic.AddUint64(&lastIdentifier, 1)
	handlers.PushBack(callbackElt{Ident: ident, Func: f})

	return CallbackIdentifier{name: name, ident: ident}
}

// RemoveCallback removes a previously-registered callback function using the
// identifier returned from AddCallback.
func (r *Registry) RemoveCallback(ident CallbackIdentifier) {
	r.lock.Lock()
	defer r.lock.Unlock()
	if r.copyOnWrite[ident.name] {
		r.copyHandlers(ident.name)
	}
	handlers := r.callbacks[ident.name]
	if handlers != nil {
		for e := handlers.Front(); e != nil; e = e.Next() {
			if e.Value.(callbackElt).Ident == ident.ident {
				handlers.Remove(e)
				break
			}
		}
	}
}

// RemoveAllCallbacks removes all callbacks for the given name.
func (r *Registry) RemoveAllCallbacks(name string) {
	r.lock.Lock()
	defer r.lock.Unlock()
	r.copyOnWrite[name] = false
	r.callbacks[name] = nil
}

// Clear removes all callbacks.
func (r *Registry) Clear() {
	r.lock.Lock()
	defer r.lock.Unlock()
	r.copyOnWrite = make(map[string]bool)
	r.callbacks = make(map[string]*list.List)
}

// Dispatch dispatches the given callback with the given args.
// If a registered handler is incompatible with the args, a panic is thrown.
// The rationale is the error lies in the code that registers the callback,
// not the code that dispatches it, but the error can't be detected until
// dispatch. This assumes, of course, that the same event isn't dispatched
// with disparate argument types.
//
// If a registered handler has too few arguments, it is only given the
// arguments it can handle If it has too many arguments, the extra arguments
// are zero-initialized.
//
// The return value is true if any handlers were invoked, or false otherwise.
func (r *Registry) Dispatch(name string, args ...interface{}) bool {
	var handlers *list.List
	var dispatch func(*list.List, ...interface{})
	func() {
		r.lock.Lock()
		defer r.lock.Unlock()
		r.copyOnWrite[name] = true
		handlers = r.callbacks[name]
		dispatch = r.dispatch
	}()
	if handlers != nil && handlers.Front() != nil {
		dispatch(handlers, args...)
		return true
	}
	return false
}

// DispatchWithBehavior is the same as Dispatch, but it dispatches using the
// given behavior instead of the one provided to New().
func (r *Registry) DispatchWithBehavior(name string, behavior int, args ...interface{}) bool {
	dispatch, ok := dispatchers[behavior]
	if !ok {
		panic("unknown behavior")
	}
	var handlers *list.List
	func() {
		r.lock.Lock()
		defer r.lock.Unlock()
		r.copyOnWrite[name] = true
		handlers = r.callbacks[name]
	}()
	if handlers != nil && handlers.Front() != nil {
		dispatch(handlers, args...)
		return true
	}
	return false
}

func dispatchSerial(handlers *list.List, args ...interface{}) {
	for e := handlers.Front(); e != nil; e = e.Next() {
		dispatch(e.Value.(callbackElt).Func, args...)
	}
}

func dispatchParallel(handlers *list.List, args ...interface{}) {
	for e := handlers.Front(); e != nil; e = e.Next() {
		go dispatch(e.Value.(callbackElt).Func, args...)
	}
}

func dispatchParallelAndWait(handlers *list.List, args ...interface{}) {
	var wg sync.WaitGroup
	for e := handlers.Front(); e != nil; e = e.Next() {
		wg.Add(1)
		value := e.Value
		go func() {
			dispatch(value.(callbackElt).Func, args...)
			wg.Done()
		}()
	}
	wg.Wait()
}

func dispatch(f interface{}, args ...interface{}) {
	fv := reflect.ValueOf(f)
	typ := fv.Type()
	numReq := typ.NumIn()
	numVals := numReq
	if typ.IsVariadic() {
		numReq-- // variadic can be []
		numVals--
		if len(args) > numReq {
			numVals = len(args)
		}
	}
	fargs := make([]reflect.Value, numVals)
	for i := 0; i < numVals; i++ {
		if i < len(args) {
			fargs[i] = reflect.ValueOf(args[i])
		} else if i >= numReq {
			// must be a variadic function
			fargs[i] = reflect.Zero(typ.In(numReq).Elem())
		} else {
			fargs[i] = reflect.Zero(typ.In(i))
		}
	}
	fv.Call(fargs)
}

func validate(f interface{}) {
	val := reflect.ValueOf(f)
	if !val.IsValid() || val.Kind() != reflect.Func || val.IsNil() {
		panic("expected function")
	}
	if val.Type().NumOut() != 0 {
		panic("function must not have return values")
	}
}

// the lock must be held already when this is called
func (r *Registry) copyHandlers(name string) {
	r.callbacks[name] = copyList(r.callbacks[name])
	r.copyOnWrite[name] = false
}

// shallow copy
func copyList(l *list.List) *list.List {
	var newl *list.List
	if l != nil {
		newl = list.New()
		for e := l.Front(); e != nil; e = e.Next() {
			newl.PushBack(e.Value)
		}
	}
	return newl
}
