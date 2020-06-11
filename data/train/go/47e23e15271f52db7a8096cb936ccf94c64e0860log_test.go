package broker_test

import (
	"github.com/buptmiao/msgo/broker"
	"testing"
)

func EatPanic(s chan struct{}) {
	if r := recover(); r != nil {
		s <- struct{}{}
	}
}

func TestLogger_Info(t *testing.T) {
	broker.EnableDebug()
	broker.DisableDebug()
	broker.Log.Level()
	broker.Log.SetLevel(broker.LEVELOFF)
	broker.Log.Printf("")
	broker.Log.Print("")
	broker.Log.Println("")

	broker.Log.SetLevel(broker.LEVELON)
	broker.Log.Printf("")
	broker.Log.Print("")
	broker.Log.Println("")

	s := make(chan struct{}, 1)
	func() {
		defer EatPanic(s)
		broker.Log.Panicf("")
	}()
	<-s
	func() {
		defer EatPanic(s)
		broker.Log.Panicln("")
	}()
	<-s
	func() {
		defer EatPanic(s)
		broker.Log.Panic("")
	}()
	<-s
	broker.Log.SetFlags(0)
	if broker.Log.Flags() != 0 {
		panic("")
	}

	broker.Log.SetPrefix("123")
	if broker.Log.Prefix() != "123" {
		panic("123")
	}
}
