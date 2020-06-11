package process

import (
	"sync"

	"github.com/gorilla/mux"
)

func RegisterRoutes(router *mux.Router) {
	r := &root{
		itemsmu: &sync.Mutex{},
		items:   map[string]*process{},
	}

	router.HandleFunc("/process", r.get).Methods("GET")
	router.HandleFunc("/process", r.createProcess).Methods("POST")
	router.HandleFunc("/process/{proc}", r.getProcess).Methods("GET")
	router.HandleFunc("/process/{proc}/start", r.startProcess).Methods("POST")
	router.HandleFunc("/process/{proc}/stop", r.stopProcess).Methods("POST")
	router.HandleFunc("/process/{proc}/stdin", r.stdinProcess).Methods("POST")
	router.HandleFunc("/process/{proc}/stdout", r.stdoutProcess).Methods("GET")
	router.HandleFunc("/process/{proc}/stderr", r.stderrProcess).Methods("GET")
	router.HandleFunc("/process/{proc}", r.deleteProcess).Methods("DELETE")
}
