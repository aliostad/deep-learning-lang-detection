package main

import (
	"fmt"
	"gopkg.in/dispatch.v1"
)

type I int

func main() {

	// setup the dispatcher
	d := dispatch.New()

	// we may have fallback functions for unhandled types
	fallback := func(in interface{}, out interface{}) (didHandle bool, err error) {
		didHandle = true
		fmt.Printf("fallback for %#v\n", in)
		return
	}

	d.AddFallback(fallback)

	// here the functions that are used for the different types
	// they have to cast to the type they serve, but they don't
	// need to check for type casting of the interface.
	// they should however return an error for other situations
	d.SetHandler("",
		func(in interface{}, out interface{}) (err error) {
			fmt.Printf("%s is a string\n", in.(string))
			return
		})

	d.SetHandler(I(0),
		func(in interface{}, out interface{}) (err error) {
			fmt.Printf("%d is a I\n", in.(I))
			return
		})

	// let the fun begin!
	d.Dispatch("my string", "") // my string is a string
	d.Dispatch(I(3), "")        // 3 is a I
	d.Dispatch(34, "")          // fallback for 34
}
