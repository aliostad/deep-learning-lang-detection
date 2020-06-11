/*
Package dispatch is HTTP request multiplexer compatible with ServeMux of net/http.

For example:
	package main

	import (
		"fmt"
		"log"
		"net/http"

		"github.com/i2bskn/dispatch"
	)

	func hello(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello %s!", dispatch.Param(r, "name"))
	}

	func main() {
		mux := dispatch.New()
		mux.HandleFunc("/hello/:name", hello)
		mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
			fmt.Fprint(w, "Home!")
		})

		log.Fatal(http.ListenAndServe(":8080", mux))
	}
*/
package dispatch
