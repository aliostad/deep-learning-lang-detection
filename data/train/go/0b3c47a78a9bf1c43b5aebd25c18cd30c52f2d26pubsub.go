package pubsub

import "errors"

var ErrBrokerSaturated = errors.New("Broker subscriber limit reached, cannot add new subscriber")

type Callback func(interface{}) bool

type Broker struct {
	subscribers    chan Callback
	maxSubscribers int
}

func NewBroker(maxSubscribers int) *Broker {
	return &Broker{maxSubscribers: maxSubscribers, subscribers: make(chan Callback, maxSubscribers)}
}

func (b *Broker) Publish(m interface{}) {
	close(b.subscribers)
	newSubscribers := make(chan Callback, b.maxSubscribers)
	for cb := range b.subscribers {
		if resubscribe := cb(m); resubscribe {
			newSubscribers <- cb
		}
	}
	b.subscribers = newSubscribers
}

func (b *Broker) Subscribe(cb Callback) error {
	select {
	case b.subscribers <- cb:
		return nil
	default:
		return ErrBrokerSaturated
	}
}
