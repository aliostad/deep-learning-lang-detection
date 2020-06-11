package events_test

import (
	. "github.com/bbengfort/x/events"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("Event Dispatcher", func() {

	var FooEvent = Type(42)
	var BarEvent = Type(64)

	It("should dispatch events to registered callbacks", func() {
		dispatcher := new(Dispatcher)
		dispatcher.Init(nil)

		var count int
		dispatcher.Register(FooEvent, func(e Event) error {
			count += 1
			return nil
		})
		dispatcher.Register(FooEvent, func(e Event) error {
			count += 10
			return nil
		})
		dispatcher.Register(BarEvent, func(e Event) error {
			count += 100
			return nil
		})

		dispatcher.Dispatch(FooEvent, nil)
		Ω(count).Should(Equal(11))
	})

	It("should be able to add and remove callbacks", func() {
		var count int
		cb0 := func(e Event) error {
			count += 1
			return nil
		}
		cb1 := func(e Event) error {
			count += 10
			return nil
		}

		dispatcher := new(Dispatcher)
		dispatcher.Init(nil)

		dispatcher.Register(FooEvent, cb0)
		dispatcher.Register(FooEvent, cb1)
		dispatcher.Dispatch(FooEvent, nil)
		dispatcher.Remove(FooEvent, cb0)
		dispatcher.Dispatch(FooEvent, nil)
		Ω(count).Should(Equal(21))

	})

	It("should pass an event to callbacks", func() {
		dispatcher := new(Dispatcher)
		dispatcher.Init("source")

		dispatcher.Register(BarEvent, func(e Event) error {
			Ω(e.Type()).Should(Equal(BarEvent))
			Ω(e.Source()).Should(Equal("source"))
			Ω(e.Value()).Should(Equal("value"))
			return nil
		})

		dispatcher.Dispatch(FooEvent, "value")
	})

	It("should ignore events with no callbacks", func() {
		// TODO: how to make assertions on this?

		dispatcher := new(Dispatcher)
		dispatcher.Init("source")
		dispatcher.Dispatch(FooEvent, "value")
	})

})
