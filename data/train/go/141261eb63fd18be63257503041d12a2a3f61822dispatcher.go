package dispatcher

import (
	"net/http"
	"regexp"
)

type Dispatcher interface {
	Dispatch(*http.Request) http.Handler
}

type DispatchFunc func(*http.Request) http.Handler

func (df DispatchFunc) Dispatch(r *http.Request) http.Handler {
	return df(r)
}

type dispatch struct {
	Dispatcher
}

func (d *dispatch) Wrap(in http.Handler) (out http.Handler) {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		d.Dispatch(r).ServeHTTP(w, r)
	})
}

func Dispatch(d Dispatcher) *dispatch {
	return &dispatch{d}
}

type Matcher interface {
	Match(*http.Request) bool
}

type matchHandler struct {
	Matcher
	http.Handler
}

type dispatchMap []matchHandler

// first match counts
func (dm dispatchMap) Dispatch(r *http.Request) http.Handler {
	for _, mh := range dm {
		if mh.Match(r) {
			return mh.Handler
		}
	}
	return nil
}

// fallthrough, last in rack will be 404 handler (you may use it with first wrapper)
func (dm dispatchMap) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	h := dm.Dispatch(r)
	if h != nil {
		h.ServeHTTP(w, r)
	}
}

type MatchHost string

func (mh MatchHost) Match(r *http.Request) bool {
	return r.URL.Host == string(mh)
}

// data should be pairs of Matcher and http.Handler
func Match(data ...interface{}) http.Handler {
	m := dispatchMap{}
	for i := 0; i < len(data); i += 2 {
		m = append(m, matchHandler{data[i].(Matcher), data[i+2].(http.Handler)})
	}
	return m
}

type MatchHostRegex regexp.Regexp

func (mhr *MatchHostRegex) Match(r *http.Request) bool {
	rg := regexp.Regexp(*mhr)
	return (&rg).MatchString(r.URL.Host)
}

type MatchScheme string

func (m MatchScheme) Match(r *http.Request) bool {
	return r.URL.Scheme == string(m)
}

type MatchQuery struct {
	key, val string
}

func (m MatchQuery) Match(r *http.Request) bool {
	return r.URL.Query().Get(m.key) == m.val
}
