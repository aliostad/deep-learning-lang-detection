package main

import "fmt"

type Broker interface {
	Handle(string)
}

type DefaultBroker struct {
	name string
}

func Init(n string) *DefaultBroker {
	return &DefaultBroker{name: n}
}

func (b *DefaultBroker) Handle(s string) {
	fmt.Printf("R:%s %s\n", b.name, s)
}

func FloorB(b *DefaultBroker) {
	fmt.Println("FloorB on ", b.name)
}

type FooBroker struct {
	name  string
	field int
}

func (f *FooBroker) Handle(s string) {
	fmt.Println("On Handle FOOO ", s, f.name, f.field)
}

func Floor(b Broker) {
	fmt.Println("Floor on ", b)
	b.Handle("blaaa")
}

type Composition struct {
	Broker

	bar string
}

func (c *Composition) Run(r string) {
	c.Handle(r)
	c.Broker.Handle(r)
}
