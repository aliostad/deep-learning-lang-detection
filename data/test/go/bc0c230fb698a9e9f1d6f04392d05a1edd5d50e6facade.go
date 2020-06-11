
package main

import (
	"github.com/gorilla/mux"
)

type Facade interface {
	Register()
	Composite() []Facade
	Manager() Manager
	Router() *mux.Router
}

type AbstractFacade struct {
	Facade
	manager Manager
	composite []Facade
}

func NewFacade(m Manager, composite []Facade) Facade {
	f := new(AbstractFacade)
	f.manager = m
	f.composite = composite
	return f
}

func (f *AbstractFacade) Manager() Manager {
	return f.manager
}

func (f *AbstractFacade) Composite() []Facade {
	return f.composite
}

func (f *AbstractFacade) Router() *mux.Router {
	c := f.Manager().Director().Context()
	return c.Router()
}

func (f *AbstractFacade) Register() {
	for _,each := range f.composite {
		each.Register()
	}
}

