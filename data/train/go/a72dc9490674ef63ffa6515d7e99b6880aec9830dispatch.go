package dispatch

import (
	"net/http"
	"net/url"
	"strings"
	"sync"
)

type Dispatch struct {
	mu       sync.RWMutex
	routes   map[string]*Dispatch
	handler  http.Handler
	explicit bool
}

// NewDispatch returns a new Dispatch
func NewDispatch() *Dispatch {

	return &Dispatch{
		mu:     sync.RWMutex{},
		routes: make(map[string]*Dispatch),
	}

	return nil
}

func (d *Dispatch) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	//d.route(statswriter.NewStatsWriter(w), r)
	d.route(w, r)
}

func (d *Dispatch) AddNamespace(pattern string, h http.Handler) {

	tokens := strings.SplitAfter(pattern, "/")

	n := len(tokens)
	if n > 0 && tokens[n-1] == "" {
		tokens = tokens[:n-1]
	}

	d.addNamespace(tokens, h)

}

func (d *Dispatch) addNamespace(pattern []string, h http.Handler) {

	// Should not happen.
	if len(pattern) == 0 {
		return
	}

	var dn *Dispatch
	var ok = false

	d.mu.Lock()
	if dn, ok = d.routes[pattern[0]]; !ok {
		dn = NewDispatch()
		d.routes[pattern[0]] = dn
	}
	d.mu.Unlock()

	if len(pattern) == 1 {
		dn.add(pattern[0], d, h)
	} else {
		dn.addNamespace(pattern[1:], h)
	}
}

func (d *Dispatch) add(pattern string, p *Dispatch, h http.Handler) {

	d.mu.Lock()
	defer d.mu.Unlock()

	d.handler = h
	d.explicit = true

	n := len(pattern)
	if n > 0 && pattern[n-1] == '/' && pattern != "/" {
		if _, ok := d.routes[pattern[0:n-1]]; !ok {
			url := &url.URL{Path: pattern}
			dn := NewDispatch()
			dn.handler = RedirectHandler(url.String(), http.StatusMovedPermanently)
			p.routes[pattern[0:n-1]] = dn
		}
	}
}

func (d *Dispatch) route(w http.ResponseWriter, r *http.Request) {

	pattern := strings.SplitAfter(r.URL.Path, "/")
	n := len(pattern)
	if n > 0 && pattern[n-1] == "" {
		n--
		pattern = pattern[:n]
	}

	if _, h := d.match(pattern); h != nil {
		h.ServeHTTP(w, r)
		return
	}

	http.NotFound(w, r)
}

func (d *Dispatch) match(pattern []string) (rd *Dispatch, rh http.Handler) {

	if len(pattern) == 0 {
		return d, nil
	}

	d.mu.RLock()
	dn, ok := d.routes[pattern[0]]
	if !ok {
		rd = d
		rh = d.handler
		d.mu.RUnlock()
		return
	}

	rd = dn
	rh = dn.handler
	d.mu.RUnlock()

	if r, h := dn.match(pattern[1:]); h != nil {
		return r, h
	}

	return
}

type redirectHandler struct {
	url  string
	code int
}

func (rh *redirectHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	http.Redirect(w, r, rh.url, rh.code)
}

func RedirectHandler(url string, code int) http.Handler {
	return &redirectHandler{url, code}
}
