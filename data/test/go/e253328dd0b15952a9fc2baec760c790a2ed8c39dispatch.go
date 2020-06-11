package dispatch

import (
	"net/http"
	"strings"
	"sync"

	"github.com/mbrumlow/brumlow_io/logger"
	"github.com/mbrumlow/brumlow_io/statswriter"
)

type Dispatch struct {
	mu     sync.RWMutex
	routes map[string]http.Handler
}

// NewDispatch returns a new Dispatch
func NewDispatch() *Dispatch {

	return &Dispatch{
		mu:     sync.RWMutex{},
		routes: make(map[string]http.Handler),
	}

	return nil
}

func (d *Dispatch) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	d.route(statswriter.NewStatsWriter(w), r)
}

func (d *Dispatch) AddNamespace(n string, h http.Handler) {
	d.mu.Lock()
	defer d.mu.Unlock()
	d.routes[n] = h
}

func (d *Dispatch) route(w *statswriter.StatsWriter, r *http.Request) {

	defer logger.Access(w, r)

	// TODO - Handle speical cases for polymer modules and components.

	if h, ok := d.handler(r); ok {
		h.ServeHTTP(w, r)
	} else {
		http.NotFound(w, r)
	}
}

func (d *Dispatch) handler(r *http.Request) (http.Handler, bool) {

	d.mu.RLock()
	defer d.mu.RUnlock()

	n := namespace(r)

	var ok bool
	var h http.Handler

	if h, ok = d.routes[n]; !ok {
		h, ok = d.routes["/"]
	}

	return h, ok
}

func namespace(r *http.Request) string {
	tokens := strings.Split(r.URL.Path, "/")
	if len(tokens) == 0 {
		return ""
	}
	return tokens[0]
}
