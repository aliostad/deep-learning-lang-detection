package vstore

import (
	"github.com/gopherjs/vecty"
	"sync"
)

// store is the main redux-like store. Use it to access the State properties.
type Store interface {
	Connect(comp StoreComponent) StoreComponent
	Dispatch(action interface{})
	State() interface{}
}

// store satisfies Store.
type store struct {
	r   Reducer
	mws []Middleware

	mtx   sync.Mutex
	comps map[*storeComponent]bool
}

// Middleware is a simple middleware that gets called before any Reduce calls.
type Middleware func(action interface{})

// New returns a store that you can make global dispatches to in order
// to update the passed global state.
func New(r Reducer, mws ...Middleware) Store {
	return &store{r: r, mws: mws, comps: map[*storeComponent]bool{}}
}

// Dispatch takes an action and passes it to all middlewares and the Reduce function.
// NOTE: dispatch is called in a goroutine.
// NOTE: vecty.Rerender is called in a goroutine for each subscribed component.
func (s *store) Dispatch(action interface{}) {
	go s.dispatch(action)
}

// State returns global state.
func (s *store) State() interface{} {
	return s.r
}

// sub subscribes a component to any store updates.
func (s *store) sub(comp *storeComponent) {
	s.mtx.Lock()
	defer s.mtx.Unlock()

	s.comps[comp] = true
}

// unsub unsubscribes a component to any store updates.
func (s *store) unsub(comp *storeComponent) {
	s.mtx.Lock()
	defer s.mtx.Unlock()

	delete(s.comps, comp)
}

// dispatch is called from Dispatch.
func (s *store) dispatch(action interface{}) {
	for _, m := range s.mws {
		m(action)
	}

	s.mtx.Lock()
	defer s.mtx.Unlock()
	s.r.Reduce(action)

	for comp := range s.comps {
		go s.rerender(comp)
	}
}

// rerender connects the store to the component and calls vecty.Rerender on the component.
func (s *store) rerender(comp *storeComponent) {
	comp.Connect(s)
	vecty.Rerender(comp)
}
