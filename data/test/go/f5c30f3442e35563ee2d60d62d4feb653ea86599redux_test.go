package goredux

import "testing"

type State struct {
	val int
}

const keyName = "MyState"

func (s *State) Reduce(a Actioner) StateReducer {
	state := State{val: s.val}
	switch a.Action() {
	case "add":
		state.val++
	case "sub":
		state.val--
	}
	return &state
}

func (s *State) Key() string {
	return keyName
}

func (s *State) Listen(sr StateReducer) {
	if _, ok := sr.(*State); !ok {
		panic("Not State")
	}
}

func Listen(sr StateReducer) {
	if _, ok := sr.(*State); !ok {
		panic("Not State")
	}
}

func TestRedux(t *testing.T) {
	s := State{}
	a := BasicAction{Act: "add", KeyName: keyName}
	redux := New(&s)

	redux.Subscribe(keyName, s.Listen)
	redux.Subscribe(keyName, Listen)

	redux.Dispatch(&a)
	redux.Dispatch(&a)
	redux.Dispatch(&a)
	redux.Dispatch(&a)
	redux.Dispatch(&a)

	v, _ := redux.State(keyName)
	ns := v.(*State)
	if ns.val != 5 {
		t.Errorf("Expected 5 got %v\n", ns.val)
	}
}
