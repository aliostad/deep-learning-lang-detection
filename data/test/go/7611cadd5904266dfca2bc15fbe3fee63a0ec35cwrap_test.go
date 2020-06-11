package goredux

import "testing"

const wrapKeyName = "DATA"

type SomeData struct {
	Val int
}

func TestWrap(t *testing.T) {
	data := SomeData{}
	addAction := &BasicAction{Act: "+", KeyName: wrapKeyName}
	subAction := &BasicAction{Act: "-", KeyName: wrapKeyName}

	ws := WrapState(&data, wrapKeyName, func(i interface{}, a Actioner) interface{} {
		s, ok := i.(*SomeData)
		if !ok {
			return i
		}
		switch a.Action() {
		case "+":
			return &SomeData{Val: s.Val + 1}
		case "-":
			return &SomeData{Val: s.Val - 1}
		}
		return i
	})

	redux := New(ws)

	redux.Dispatch(addAction)
	redux.Dispatch(addAction)
	redux.Dispatch(subAction)
	redux.Dispatch(addAction)
	redux.Dispatch(addAction)
	redux.Dispatch(subAction)

	ns, _ := redux.State(wrapKeyName)
	newData := ns.(*WrappedState).State.(*SomeData)
	if newData.Val != 2 {
		t.Errorf("Expected 2 got %v\n", newData.Val)
	}
}
