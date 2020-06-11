package gudispatch

import (
	"github.com/go-humble/detect"
	"github.com/influx6/faux/loop"
	"github.com/influx6/faux/mque"
)

//==============================================================================

// history provides a central URL coordinator for gu views.
var history *HistoryProvider

// dispatch provides a default dispatcher for listening to events.
var dispatch = mque.New()

// Subscribe adds a new listener to the dispatcher.
func Subscribe(q interface{}) loop.Looper {
	return dispatch.Q(q)
}

// Dispatch emits a event into the dispatch callback listeners.
func Dispatch(q interface{}) {
	dispatch.Run(q)
}

// Navigate changes the URI path of the host browser accordingly.
func Navigate(q string) {
	if history != nil {
		history.Go(q)
	}
}

// Follow calls a redirection of the history router with the follow information.
func Follow(host, path, hash string) {
	if history != nil {
		history.Follow(host, path, hash)
	}
}

//==============================================================================

// init intializes the internal state management variables used in dispatch.
func init() {
	if detect.IsBrowser() {
		history = History(HashSequencer)
	}
}
