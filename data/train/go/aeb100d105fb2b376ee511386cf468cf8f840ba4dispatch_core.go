/*
Package dispatch is used to dispatch irc messages to event handlers in an
concurrent fashion. It supports various event handler types to easily
extract information from events, as well as define more succint handlers.
*/
package dispatch

import (
	"runtime"
	"strings"
	"sync"

	"github.com/aarondl/ultimateq/irc"
	"gopkg.in/inconshreveable/log15.v2"
)

// DispatchCore is a core for any dispatching mechanisms that includes a sync'd
// list of channels, channel identification services, and a waiter to
// synchronize the exit of all the event handlers sharing this core.
type DispatchCore struct {
	log     log15.Logger
	waiter  sync.WaitGroup
	chans   []string
	protect sync.RWMutex
}

// NewDispatchCore initializes a dispatch core
func NewDispatchCore(logger log15.Logger, chans ...string) *DispatchCore {
	d := &DispatchCore{log: logger}
	d.channels(chans)

	return d
}

// SetChannels sets the active channels for this dispatcher.
func (d *DispatchCore) SetChannels(chans []string) {
	d.protect.Lock()
	d.channels(chans)
	d.protect.Unlock()
}

// Channels gets the active channels for this dispatcher.
func (d *DispatchCore) Channels() (chans []string) {
	d.protect.Lock()
	defer d.protect.Unlock()

	if d.chans == nil {
		return
	}
	chans = make([]string, len(d.chans))
	copy(chans, d.chans)
	return
}

// AddChannels adds channels to the active channels for this dispatcher.
func (d *DispatchCore) AddChannels(chans ...string) {
	if 0 == len(chans) {
		return
	}
	d.protect.Lock()
	defer d.protect.Unlock()

	if d.chans == nil {
		d.chans = make([]string, 0, len(chans))
	}

	for i := 0; i < len(chans); i++ {
		addchan := strings.ToLower(chans[i])
		found := false
		for j, length := 0, len(d.chans); j < length; j++ {
			if d.chans[j] == addchan {
				found = true
				break
			}
		}
		if !found {
			d.chans = append(d.chans, addchan)
		}
	}
}

// RemoveChannels removes channels to the active channels for this dispatcher.
func (d *DispatchCore) RemoveChannels(chans ...string) {
	if 0 == len(chans) {
		return
	}
	d.protect.Lock()
	defer d.protect.Unlock()

	if d.chans == nil || 0 == len(d.chans) {
		return
	}

	for i := 0; i < len(chans); i++ {
		removechan := strings.ToLower(chans[i])
		for j, length := 0, len(d.chans); j < length; j++ {
			if d.chans[j] == removechan {
				if length == 1 {
					d.chans = nil
					return
				}
				if j < length-1 {
					d.chans[j], d.chans[length-1] =
						d.chans[length-1], d.chans[j]
				}
				d.chans = d.chans[:length-1]
				length--
			}
		}
	}
}

// channels sets the active channels for this dispatcher. Not thread
// safe.
func (d *DispatchCore) channels(chans []string) {
	length := len(chans)
	if length == 0 {
		d.chans = nil
	} else {
		d.chans = make([]string, length)
		for i := 0; i < length; i++ {
			d.chans[i] = strings.ToLower(chans[i])
		}
	}
}

// HandlerStarted tells the core that a handler has started and it should be
// waited on.
func (d *DispatchCore) HandlerStarted() {
	d.waiter.Add(1)
}

// HandlerFinished tells the core that a handler has ended.
func (d *DispatchCore) HandlerFinished() {
	d.waiter.Done()
}

// WaitForHandlers waits for the unfinished handlers to finish.
func (d *DispatchCore) WaitForHandlers() {
	d.waiter.Wait()
}

// CheckTarget describes a dispatching target. It checks both if it is a
// channel, and if it is a channel, if that channel is an active one for
// this dispatchcore.
func (d *DispatchCore) CheckTarget(ev *irc.Event) (isChan, hasChan bool) {
	d.protect.RLock()
	defer d.protect.RUnlock()

	isChan = ev.IsTargetChan()
	hasChan = isChan && d.hasChannel(strings.ToLower(ev.Target()))
	return isChan, hasChan
}

// hasChannel checks to see if the dispatch core's channel list includes a
// channel.
func (d *DispatchCore) hasChannel(channel string) bool {
	if len(d.chans) == 0 {
		return true
	}

	targ := strings.ToLower(channel)
	for i := 0; i < len(d.chans); i++ {
		if targ == d.chans[i] {
			return true
		}
	}
	return false
}

// PanicHandler catches any panics and logs a stack trace
func (d *DispatchCore) PanicHandler() {
	recovered := recover()
	if recovered == nil {
		return
	}
	buf := make([]byte, 1024)
	runtime.Stack(buf, false)
	d.log.Error("Handler failed", "panic", recovered)
	d.log.Error(string(buf))
}
