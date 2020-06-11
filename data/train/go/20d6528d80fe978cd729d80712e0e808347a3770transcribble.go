package main

import (
	"os"
	"net/http"
	"github.com/gorilla/mux"
	"github.com/zacharycarter/transcribble/handlers"
)

type instrument struct {
	name string
}

type note struct {
	pitch string
	instrument instrument
	beat uint8
}

type staff struct {
	measures uint16
	music map[uint16][]note
}

type transcribble struct {
	timeSignature float32
}

var global struct {
	transcribbleInstance *transcribble
}

func main() {
	initialize(os.Args)
}

func initialize(args []string) {
	// instance := GetTranscribbleInstance()
	indexHandler := &handlers.IndexHandler{}

	r := mux.NewRouter()
	r.HandleFunc("/", indexHandler.Handle)
    r.PathPrefix("/").Handler(http.FileServer(http.Dir(".")))
    http.Handle("/", r)
    http.ListenAndServe(":8080", nil)
}

func GetTranscribbleInstance() *transcribble {
	if global.transcribbleInstance == nil {
		global.transcribbleInstance = &transcribble{}
	}
	return global.transcribbleInstance
}