package store

import "fmt"

var State interface{}
var Reducer func(state interface{}, action interface{}) interface{}
var listeners map[interface{}]func()
var Dispatch chan interface{}

func Subscribe(key interface{}, listener func()) {
	if key == nil {
		key = new(int)
	}
	if _, ok := listeners[key]; ok {
		panic(fmt.Sprintf("listener with key already exists: %v", key))
	}
	listeners[key] = listener
}

func Unsubscribe(key interface{}) {
	delete(listeners, key)
}

func init() {
	listeners = make(map[interface{}]func())
	Dispatch = make(chan interface{})
	go func() {
		for {
			action := <-Dispatch
			State = Reducer(State, action)
			for _, l := range listeners {
				l()
			}
		}
	}()
}
