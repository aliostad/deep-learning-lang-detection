package pool

import "expvar"

const (
	// ExpvarKeyGets is the key name for the expvar that captures pool
	// get requests. Pass it to expvar.Get to inspect current statistics.
	ExpvarKeyGets = "srvproxy_pool_gets"
)

var (
	gets = expvar.NewInt(ExpvarKeyGets)
)

// Instrument records metrics for operations against the wrapped Pool.
func Instrument(next Pool) Pool {
	return instrument{next}
}

type instrument struct {
	next Pool
}

func (i instrument) Get() (string, error) {
	gets.Add(1)
	return i.next.Get()
}

func (i instrument) Close() {
	i.next.Close()
}
