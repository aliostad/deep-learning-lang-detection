package dispatch

import (
	"github.com/asteris-llc/pushmipullyu/Godeps/_workspace/src/github.com/Sirupsen/logrus"
	"github.com/asteris-llc/pushmipullyu/Godeps/_workspace/src/golang.org/x/net/context"
)

// Dispatch manages a dispatcher function. It handles registration.
type Dispatch struct {
	in       chan Message
	handlers map[string][]chan Message
}

// Message is passed around to everybody. It wraps a payload and tag.
type Message struct {
	Tag     string
	Payload interface{}
}

// New creates a new empty dispatch and starts it running
func New() *Dispatch {
	return &Dispatch{
		in:       make(chan Message, 0),
		handlers: map[string][]chan Message{},
	}
}

// Send takes an event tag and a payload and dispatches it as soon as possible.
func (d *Dispatch) Send(tag string, payload interface{}) {
	d.in <- Message{tag, payload}
}

// Register registers a function for a tag and returns a channel on which events
// will be sent for that tag.
func (d *Dispatch) Register(tags ...string) chan Message {
	out := make(chan Message, 1)

	for _, tag := range tags {
		current, ok := d.handlers[tag]
		if ok {
			d.handlers[tag] = append(current, out)
		} else {
			d.handlers[tag] = []chan Message{out}
		}
	}

	logrus.WithField("tags", tags).Debug("registered handler")
	return out
}

// Run begins the dispatch process
func (d *Dispatch) Run(ctx context.Context) {
	for {
		select {
		case value := <-d.in:
			if targets, ok := d.handlers[value.Tag]; ok {
				logrus.WithField("tag", value.Tag).Debug("received message matching tag, dispatching")
				for _, t := range targets {
					t <- value
				}
			} else {
				logrus.WithField("tag", value.Tag).Debug("no handlers registered")
			}
		case <-ctx.Done():
			logrus.Info("dispatch received shutdown event")
			return
		}
	}
}
