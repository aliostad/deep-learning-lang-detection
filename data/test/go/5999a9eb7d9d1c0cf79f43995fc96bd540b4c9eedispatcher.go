package dispatch

import (
	"github.com/go-humble/detect"
	"github.com/influx6/gu/dispatch/mque"
)

//==============================================================================

// history provides a central URL coordinator for gu.
var history *HistoryProvider

// dispatch provides a default dispatcher for listening to events.
var dispatch = mque.New()

// Subscribe adds a new listener to the dispatcher.
func Subscribe(q interface{}, end ...func()) mque.End {
	return dispatch.Q(q, end...)
}

// Dispatch emits a event into the dispatch callback listeners.
func Dispatch(q interface{}) {
	dispatch.Run(q)
}

//==============================================================================

// init intializes the internal state management variables used in dispatch.
func init() {
	if detect.IsBrowser() {
		history = History(HashSequencer)

		// Initiate to the current path.
		history.Follow(GetLocation())
	}
}
