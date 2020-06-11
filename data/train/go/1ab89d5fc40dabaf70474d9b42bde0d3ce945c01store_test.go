package godux_test

import (
	"reflect"

	. "github.com/zpencerq/godux"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("Store", func() {
	Describe("createStore", func() {
		It("Passes the initial action and the initial state", func() {
			state := []Todo{Todo{Id: 1, Text: "Hello"}}
			store := NewStore(&StoreInput{
				Reducer: Reducers["todos"],
				State:   state,
			})

			Expect(store.State()).To(Equal(state))
		})

		It("Applies the Reducer to the previous state", func() {
			store := NewStore(&StoreInput{
				Reducer: Reducers["todos"],
			})

			store.Dispatch(UnknownAction())
			Expect(store.State()).To(Equal([]Todo{}))
			store.Dispatch(UnknownAction())
			Expect(store.State()).To(Equal([]Todo{}))

			store.Dispatch(AddTodo("Hello"))
			Expect(store.State()).To(Equal([]Todo{Todo{Id: 1, Text: "Hello"}}))

			store.Dispatch(AddTodo("World"))
			Expect(store.State()).To(Equal([]Todo{
				Todo{Id: 1, Text: "Hello"},
				Todo{Id: 2, Text: "World"},
			}))
		})

		It("Applies the Reducer to the initial state", func() {
			state := []Todo{Todo{Id: 1, Text: "Hello"}}
			store := NewStore(&StoreInput{
				Reducer: Reducers["todos"],
				State:   state,
			})
			Expect(store.State()).To(Equal(state))

			store.Dispatch(UnknownAction())
			Expect(store.State()).To(Equal(state))

			store.Dispatch(AddTodo("World"))
			Expect(store.State()).To(Equal([]Todo{
				Todo{Id: 1, Text: "Hello"},
				Todo{Id: 2, Text: "World"},
			}))
		})

		It("Preserves the state when replacing a Reducer", func() {
			store := NewStore(&StoreInput{Reducer: Reducers["todos"]})
			store.Dispatch(AddTodo("Hello"))
			store.Dispatch(AddTodo("World"))
			Expect(store.State()).To(Equal([]Todo{
				Todo{Id: 1, Text: "Hello"},
				Todo{Id: 2, Text: "World"},
			}))

			store.ReplaceReducer(Reducers["todosReverse"])
			Expect(store.State()).To(Equal([]Todo{
				Todo{Id: 1, Text: "Hello"},
				Todo{Id: 2, Text: "World"},
			}))

			store.Dispatch(AddTodo("Perhaps"))
			Expect(store.State()).To(Equal([]Todo{
				Todo{Id: 3, Text: "Perhaps"},
				Todo{Id: 1, Text: "Hello"},
				Todo{Id: 2, Text: "World"},
			}))

			store.ReplaceReducer(Reducers["todos"])
			Expect(store.State()).To(Equal([]Todo{
				Todo{Id: 3, Text: "Perhaps"},
				Todo{Id: 1, Text: "Hello"},
				Todo{Id: 2, Text: "World"},
			}))

			store.Dispatch(AddTodo("Surely"))
			Expect(store.State()).To(Equal([]Todo{
				Todo{Id: 3, Text: "Perhaps"},
				Todo{Id: 1, Text: "Hello"},
				Todo{Id: 2, Text: "World"},
				Todo{Id: 4, Text: "Surely"},
			}))
		})

		It("Supports multiple subscriptions", func() {
			store := NewStore(&StoreInput{
				Reducer: Reducers["todos"],
			})

			listenerA := func() {}
			listenerB := func() {}
			spyA := MakeSpy(listenerA, &listenerA)
			spyB := MakeSpy(listenerB, &listenerB)

			unsubscribeA := store.Subscribe(listenerA)
			store.Dispatch(UnknownAction())
			Expect(spyA.Calls).To(HaveLen(1))
			Expect(spyB.Calls).To(HaveLen(0))

			store.Dispatch(UnknownAction())
			Expect(spyA.Calls).To(HaveLen(2))
			Expect(spyB.Calls).To(HaveLen(0))

			unsubscribeB := store.Subscribe(listenerB)
			Expect(spyA.Calls).To(HaveLen(2))
			Expect(spyB.Calls).To(HaveLen(0))

			store.Dispatch(UnknownAction())
			Expect(spyA.Calls).To(HaveLen(3))
			Expect(spyB.Calls).To(HaveLen(1))

			unsubscribeA()
			Expect(spyA.Calls).To(HaveLen(3))
			Expect(spyB.Calls).To(HaveLen(1))

			store.Dispatch(UnknownAction())
			Expect(spyA.Calls).To(HaveLen(3))
			Expect(spyB.Calls).To(HaveLen(2))

			unsubscribeB()
			Expect(spyA.Calls).To(HaveLen(3))
			Expect(spyB.Calls).To(HaveLen(2))

			store.Dispatch(UnknownAction())
			Expect(spyA.Calls).To(HaveLen(3))
			Expect(spyB.Calls).To(HaveLen(2))

			unsubscribeA = store.Subscribe(listenerA)
			Expect(spyA.Calls).To(HaveLen(3))
			Expect(spyB.Calls).To(HaveLen(2))

			store.Dispatch(UnknownAction())
			Expect(spyA.Calls).To(HaveLen(4))
			Expect(spyB.Calls).To(HaveLen(2))
		})

		It("Only removes listener once when unsubscribe is called", func() {
			store := NewStore(&StoreInput{
				Reducer: Reducers["todos"],
			})

			listenerA := func() {}
			listenerB := func() {}
			spyA := MakeSpy(listenerA, &listenerA)
			spyB := MakeSpy(listenerB, &listenerB)

			unsubscribeA := store.Subscribe(listenerA)
			store.Subscribe(listenerB)

			unsubscribeA()
			unsubscribeA()

			store.Dispatch(UnknownAction())
			Expect(spyA.Calls).To(HaveLen(0))
			Expect(spyB.Calls).To(HaveLen(1))
		})

		It("Only removes relevant listener when unsubscribe is called", func() {
			store := NewStore(&StoreInput{
				Reducer: Reducers["todos"],
			})

			listener := func() {}
			spy := MakeSpy(listener, &listener)
			store.Subscribe(listener)

			unsubscribeSecond := store.Subscribe(listener)

			unsubscribeSecond()
			unsubscribeSecond()

			store.Dispatch(UnknownAction())
			Expect(spy.Calls).To(HaveLen(1))
		})

		It("Supports removing a subscription within a subscription", func() {

			store := NewStore(&StoreInput{
				Reducer: Reducers["todos"],
			})

			listenerA := func() {}
			listenerB := func() {}
			listenerC := func() {}
			spyA := MakeSpy(listenerA, &listenerA)
			spyB := MakeSpy(listenerB, &listenerB)
			spyC := MakeSpy(listenerC, &listenerC)

			store.Subscribe(listenerA)

			var unSubB func()
			unSubB = store.Subscribe(func() {
				listenerB()
				unSubB()
			})

			store.Subscribe(listenerC)

			store.Dispatch(UnknownAction())
			store.Dispatch(UnknownAction())

			Expect(spyA.Calls).To(HaveLen(2))
			Expect(spyB.Calls).To(HaveLen(1))
			Expect(spyC.Calls).To(HaveLen(2))

		})

		It("Delays unsubscribe until the end of current dispatch", func() {
			store := NewStore(&StoreInput{
				Reducer: Reducers["todos"],
			})

			unsubscribeHandles := []func(){}
			doUnsubscribeAll := func() {
				for _, handle := range unsubscribeHandles {
					handle()
				}
			}

			listener1 := func() {}
			listener2 := func() {}
			listener3 := func() {}
			spy1 := MakeSpy(listener1, &listener1)
			spy2 := MakeSpy(listener2, &listener2)
			spy3 := MakeSpy(listener3, &listener3)

			unsubscribeHandles = append(unsubscribeHandles, store.Subscribe(listener1))
			unsubscribeHandles = append(unsubscribeHandles, store.Subscribe(func() {
				listener2()
				doUnsubscribeAll()
			}))
			unsubscribeHandles = append(unsubscribeHandles, store.Subscribe(listener3))

			store.Dispatch(UnknownAction())
			Expect(spy1.Calls).To(HaveLen(1))
			Expect(spy2.Calls).To(HaveLen(1))
			Expect(spy3.Calls).To(HaveLen(1))

			store.Dispatch(UnknownAction())
			Expect(spy1.Calls).To(HaveLen(1))
			Expect(spy2.Calls).To(HaveLen(1))
			Expect(spy3.Calls).To(HaveLen(1))
		})

		It("Delays subscribe until the end of current dispatch", func() {
			store := NewStore(&StoreInput{
				Reducer: Reducers["todos"],
			})

			listener1 := func() {}
			listener2 := func() {}
			listener3 := func() {}
			spy1 := MakeSpy(listener1, &listener1)
			spy2 := MakeSpy(listener2, &listener2)
			spy3 := MakeSpy(listener3, &listener3)

			listener3Added := false
			maybeAddThirdListener := func() {
				if !listener3Added {
					listener3Added = true
					store.Subscribe(func() { listener3() })
				}
			}

			store.Subscribe(func() { listener1() })
			store.Subscribe(func() {
				listener2()
				maybeAddThirdListener()
			})

			store.Dispatch(UnknownAction())
			Expect(spy1.Calls).To(HaveLen(1))
			Expect(spy2.Calls).To(HaveLen(1))
			Expect(spy3.Calls).To(HaveLen(0))

			store.Dispatch(UnknownAction())
			Expect(spy1.Calls).To(HaveLen(2))
			Expect(spy2.Calls).To(HaveLen(2))
			Expect(spy3.Calls).To(HaveLen(1))
		})

		It("Uses the last snapshot of subscribers during nested dispatch", func() {
			store := NewStore(&StoreInput{
				Reducer: Reducers["todos"],
			})

			listener1 := func() {}
			listener2 := func() {}
			listener3 := func() {}
			listener4 := func() {}
			spy1 := MakeSpy(listener1, &listener1)
			spy2 := MakeSpy(listener2, &listener2)
			spy3 := MakeSpy(listener3, &listener3)
			spy4 := MakeSpy(listener4, &listener4)

			var (
				unsubscribe1, unsubscribe4 func()
			)

			unsubscribe1 = store.Subscribe(func() {
				listener1()
				Expect(spy1.Calls).To(HaveLen(1))
				Expect(spy2.Calls).To(HaveLen(0), "unknown")
				Expect(spy3.Calls).To(HaveLen(0))
				Expect(spy4.Calls).To(HaveLen(0))

				unsubscribe1()
				unsubscribe4 = store.Subscribe(listener4)
				store.Dispatch(UnknownAction())

				Expect(spy1.Calls).To(HaveLen(1))
				Expect(spy2.Calls).To(HaveLen(1))
				Expect(spy3.Calls).To(HaveLen(1))
				Expect(spy4.Calls).To(HaveLen(1))

			})

			store.Subscribe(listener2)
			store.Subscribe(listener3)

			store.Dispatch(UnknownAction())

			Expect(spy1.Calls).To(HaveLen(1))
			Expect(spy2.Calls).To(HaveLen(2))
			Expect(spy3.Calls).To(HaveLen(2))
			Expect(spy4.Calls).To(HaveLen(1))

			unsubscribe4()
			store.Dispatch(UnknownAction())

			Expect(spy1.Calls).To(HaveLen(1))
			Expect(spy2.Calls).To(HaveLen(3))
			Expect(spy3.Calls).To(HaveLen(3))
			Expect(spy4.Calls).To(HaveLen(1))
		})

		It("Provides an up-to-date state when a subscriber is notified", func(done Done) {
			store := NewStore(&StoreInput{
				Reducer: Reducers["todos"],
			})

			store.Subscribe(func() {
				Expect(store.State()).To(Equal([]Todo{
					{Id: 1, Text: "Hello"},
				}))
				close(done)
			})

			store.Dispatch(AddTodo("Hello"))
		})

		It("Handles nested dispatches gracefully", func() {

			reducer := CombineReducers(Foo, Bar)
			store := NewStore(&StoreInput{
				Reducer: reducer,
			})

			kindaComponentDidUpdate := func() {
				state := store.State()
				if state.(map[string]interface{})["Bar"] == 0 {
					store.Dispatch(&Action{Type: "bar"})
				}
			}
			store.Subscribe(kindaComponentDidUpdate)

			store.Dispatch(&Action{Type: "foo"})

			Expect(store.State()).To(Equal(map[string]interface{}{
				"Foo": 1,
				"Bar": 2,
			}))
		})

		It("Does not allow Dispatch() from within a Reducer", func() {
			DISPATCH_IN_MIDDLE := "DISPATCH_IN_MIDDLE"

			dispatchInTheMiddleOfReducer := func(state interface{}, action *Action) interface{} {
				switch action.Type {
				case DISPATCH_IN_MIDDLE:
					action.Value.(func(*Action) *Action)(UnknownAction())
					return state
				default:
					return state
				}
			}

			store := NewStore(&StoreInput{
				Reducer: dispatchInTheMiddleOfReducer,
			})

			Expect(func() {
				store.Dispatch(&Action{
					Type:  DISPATCH_IN_MIDDLE,
					Value: store.Dispatch,
				})
			}).To(Panic())

		})

		It("Recovers from an error within a Reducer", func() {
			THROW_ERROR := "THROW_ERROR"
			reducer := func(state interface{}, action *Action) interface{} {
				if state == nil {
					state = []struct{}{}
				}

				switch action.Type {
				case THROW_ERROR:
					panic("")
				default:
					return state
				}
			}

			store := NewStore(&StoreInput{Reducer: reducer})

			Expect(func() {
				store.Dispatch(&Action{Type: THROW_ERROR})
			}).To(Panic())

			Expect(func() {
				store.Dispatch(UnknownAction())
			}).To(Not(Panic()))
		})

		It("Accepts enhancers", func() {
			var dispatchSpy *Spy
			emptyArray := []Todo{}

			spyEnhancer := func(sf StoreFactory) func(Reducer, State) *Store {
				return func(r Reducer, s State) *Store {
					Expect(reflect.ValueOf(r).Pointer()).To(Equal(reflect.ValueOf(Reducers["todos"]).Pointer()))
					Expect(s).To(Equal(emptyArray))
					vanillaStore := sf(&StoreInput{Reducer: r, State: s})

					d := vanillaStore.Dispatch
					dispatchSpy = MakeSpy(d, &d)
					return vanillaStore
				}
			}

			store := NewStore(&StoreInput{Reducers["todos"], emptyArray, spyEnhancer})
			action := AddTodo("Hello")
			store.Dispatch(action)

			Expect(dispatchSpy.WasCalledWith(action)).To(Equal(true))
			Expect(store.State()).To(Equal([]Todo{
				{Id: 1, Text: "Hello"},
			}))
		})

		It("Actions with an empty type will panic", func() {
			store := NewStore(&StoreInput{Reducer: Reducers["todos"]})
			Expect(func() { store.Dispatch(&Action{}) }).To(Panic())
		})
	})
})
