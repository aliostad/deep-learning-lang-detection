package dispatcher

import (
	"log"

	"github.com/andreadipersio/efr/event"
)

// dispatchDirectory provide storing of subscribers by their ids
type dispatchDirectory struct {
	storage           map[string]event.Subscriber
	subscriberFactory event.SubscriberFactoryType
}

// GetOrCreate try to get a subscriber from directory by its ID, if it does not exist,
// create a disconnected user
func (d *dispatchDirectory) GetOrCreate(subscriberID string) event.Subscriber {
	subscriber, exist := d.storage[subscriberID]

	if exist {
		return subscriber
	}

	d.New(subscriberID)

	return d.storage[subscriberID]
}

// GetByID mimic map lookup, returning item or nil and a boolean value
func (d *dispatchDirectory) GetByID(subscriberID string) (event.Subscriber, bool) {
	item, exist := d.storage[subscriberID]

	return item, exist
}

// Create a new disconnected directory subscriber by its ID
func (d *dispatchDirectory) New(subscriberID string) {
	log.Printf("subscriber %v registered to directory", subscriberID)
	s := d.subscriberFactory(subscriberID)

	d.storage[subscriberID] = s
}

// Subscribe register a subscriber value to directory
func (d *dispatchDirectory) Subscribe(s event.Subscriber) {
	log.Printf("subscriber %v subscribed to directory", s)
	d.storage[s.GetID()] = s
}

// UnsubscribeAll unsubscribe all subscribers by deleting them from
// the subscriber directory and, if they are connected, disconnect them
func (d *dispatchDirectory) UnsubscribeAll() {
	for subscriberID, s := range d.storage {
		if s.IsConnected() {
			s.Disconnect()
		}

		log.Printf("subscriber %v unsubscribed from directory", subscriberID)

		delete(d.storage, subscriberID)
	}
}

// Broadcast send event e to all subscribers in the directory
func (d *dispatchDirectory) Broadcast(e event.Event) {
	log.Printf("Broadcast event %v", e.SequenceNum())
	for _, s := range d.storage {
		s.SendEvent(e)
	}
}

// SenderAndRecipientFromEvent return event Sender and event Receiver.
// If they are not registered in the directory, create them.
func (d *dispatchDirectory) SenderAndRecipientFromEvent(e event.Event) (event.Subscriber, event.Subscriber) {
	return d.GetOrCreate(e.SenderID()), d.GetOrCreate(e.RecipientID())
}

// NewDirectory return an initialized directory which use subscriberFactory to
// generate new subscriber objects
func NewDirectory(subscriberFactory event.SubscriberFactoryType) *dispatchDirectory {
	return &dispatchDirectory{
		storage:           map[string]event.Subscriber{},
		subscriberFactory: subscriberFactory,
	}
}
