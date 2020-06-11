package skylink

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/stardustapp/core/base"
)

// Fake broker that just exists to serve an nsexport healthcheck

func NewPingBroker(ns *nsexport, path string) *nsexportPingBroker {
	broker := &nsexportPingBroker{
		svc:  ns,
		root: ns.root,
	}

	http.Handle(path, broker)
	log.Println("nsexport-http: mounted at", path)
	return broker
}

// Context for a stateful client connection
type nsexportPingBroker struct {
	svc  *nsexport
	root base.Context
}

func (b *nsexportPingBroker) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		http.Error(w, "Method not allowed", 405)
		return
	}

	res := map[string]bool{
		"Ok": true,
	}

	w.Header().Add("content-type", "application/json; charset=UTF-8")
	json.NewEncoder(w).Encode(res)
}
