package kk

import (
	"time"
)

type Dispatch struct {
	ch        chan func()
	loopbreak bool
	OnExit    func()
}

func NewDispatch() *Dispatch {

	var ch = make(chan func())

	var v = Dispatch{ch, false, nil}

	go func() {

		defer close(ch)

		for !v.loopbreak {
			var fn, ok = <-ch
			if !ok {
				break
			}
			if fn != nil {
				fn()
			}
		}

		if v.OnExit != nil {
			v.OnExit()
		}

	}()

	return &v
}

func (d *Dispatch) Break() {
	d.Async(func() {
		d.loopbreak = true
	})
}

func (d *Dispatch) Async(fn func()) {
	d.ch <- fn
}

func (d *Dispatch) AsyncDelay(fn func(), delay time.Duration) {
	var ch = d.ch
	go func() {
		time.Sleep(delay)
		ch <- fn
	}()
}

func (d *Dispatch) Sync(fn func()) {
	var ch = make(chan bool)
	defer close(ch)
	d.Async(func() {
		fn()
		ch <- true
	})
	<-ch
}

var _dispatch_main Dispatch = Dispatch{make(chan func()), false, nil}

func DispatchMain() {

	var ch = _dispatch_main.ch

	defer close(ch)

	for !_dispatch_main.loopbreak {
		var fn = <-ch
		if fn != nil {
			fn()
		}
	}
}

func GetDispatchMain() *Dispatch {
	return &_dispatch_main
}
