// dispatcher package implement an event dispatcher which
// dispatch incoming events to subscribers (implementing event.Subscriber interface)
// registered on a subscribers directory.
package dispatcher

import (
	"log"

	"github.com/andreadipersio/efr/event"
	"github.com/andreadipersio/efr/event/subscription"
)

const (
	BROADCAST_ETYPE = "B"
)

// Dispatcher listen for both new events and new subscription request
// dispatching events on a subscribers directory
type Dispatcher struct {
	// DispatchChan receive incoming events
	DispatchChan chan event.Event

	// SubscriptionChan receive incoming client connection
	SubscriptionChan chan *subscription.SubscriptionRequest

	// EventSourceCloseChan is passed a value when event source disconnect
	// from event listener
	EventSourceCloseChan chan interface{}

	// dispatch directory store subscribed users
	directory *dispatchDirectory

	// A function which is used to return the subscriber
	// concrete value
	SubscriberFactory event.SubscriberFactoryType
}

// Dispatch
// - receive new subscriptions on subscription channel
// - receive new events on dispatch channel
// - get notified of event source disconnection on EventSourceCloseChan
func (dsp *Dispatcher) Dispatch() {
	log.Print("=== Dispatcher started")

	for {
		select {
		case subRequest := <-dsp.SubscriptionChan:
			s := dsp.SubscriberFactory(subRequest.SubscriberID)
			s.Connect(subRequest.Conn)
			dsp.directory.Subscribe(s)
		case e := <-dsp.DispatchChan:
			// Broadcast
			if e.EventType() == BROADCAST_ETYPE {
				dsp.directory.Broadcast(e)
			} else {
				sender, recipient := dsp.directory.SenderAndRecipientFromEvent(e)
				sender.HandleEvent(e, recipient)
			}
		case <-dsp.EventSourceCloseChan:
			// EventSource disconnected
			dsp.directory.UnsubscribeAll()
		}
	}
}

func New(
	dspChan chan event.Event,
	subChan chan *subscription.SubscriptionRequest,
	ctrlChan chan interface{},
	subscriberFactory event.SubscriberFactoryType,
) *Dispatcher {
	return &Dispatcher{
		DispatchChan:         dspChan,
		SubscriptionChan:     subChan,
		EventSourceCloseChan: ctrlChan,
		SubscriberFactory:    subscriberFactory,
		directory:            NewDirectory(subscriberFactory),
	}
}
