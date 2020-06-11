package sphere

import (
	"errors"

	"github.com/streamrail/concurrent-map"
)

const (
	// BrokerErrorOverrideOnSubscribe to warn use to override OnSubsribe function
	brokerErrorOverrideOnSubscribe = "please override OnSubscribe"
	// BrokerErrorOverrideOnUnsubscribe to warn use to override OnUnsubscribe function
	brokerErrorOverrideOnUnsubscribe = "please override OnUnsubscribe"
	// BrokerErrorOverrideOnPublish to warn use to override OnPublish function
	brokerErrorOverrideOnPublish = "please override OnPublish"
	// BrokerErrorOverrideOnMessage to warn use to override OnMessage function
	brokerErrorOverrideOnMessage = "please override OnMessage"
)

// IBroker represents Broker instance
type IBroker interface {
	ID() string                            // => Broker ID
	ChannelName(string, string) string     // => Broker generate channel name with namespace and channel
	IsSubscribed(string, string) bool      // => Broker channel subscribe state
	OnSubscribe(*Channel, chan<- IError)   // => Broker OnSubscribe
	OnUnsubscribe(*Channel, chan<- IError) // => Broker OnUnsubscribe
	OnPublish(*Channel, *Packet) error     // => Broker OnPublish
	OnMessage(*Channel, *Packet) error     // => Broker OnMessage
}

// ExtendBroker creates a broker instance
func ExtendBroker() *Broker {
	return &Broker{
		id:    guid.String(),
		store: cmap.New(),
	}
}

// Broker allows you to interact directly with Websocket internal data and pub/sub channels
type Broker struct {
	// Broker ID
	id string
	// Channel store
	store cmap.ConcurrentMap
}

// ID returns the unique id for the broker
func (broker *Broker) ID() string {
	return broker.id
}

// Store returns the channel store
func (broker *Broker) Store() cmap.ConcurrentMap {
	return broker.store
}

// ChannelName returns channel name with provided namespace and room name
func (broker *Broker) ChannelName(namespace string, room string) string {
	return namespace + ":" + room
}

// IsSubscribed return the broker state of the channel
func (broker *Broker) IsSubscribed(namespace string, room string) bool {
	return broker.store.Has(broker.ChannelName(namespace, room))
}

// OnSubscribe when websocket subscribes to a channel
func (broker *Broker) OnSubscribe(channel *Channel, done chan<- IError) {
	done <- errors.New(brokerErrorOverrideOnSubscribe)
}

// OnUnsubscribe when websocket unsubscribes from a channel
func (broker *Broker) OnUnsubscribe(channel *Channel, done chan<- IError) {
	done <- errors.New(brokerErrorOverrideOnUnsubscribe)
}

// OnPublish when websocket publishes data to a particular channel from the current broker
func (broker *Broker) OnPublish(channel *Channel, data *Packet) error {
	return errors.New(brokerErrorOverrideOnPublish)
}

// OnMessage when websocket receive data from the broker subscriber
func (broker *Broker) OnMessage(channel *Channel, data *Packet) error {
	return errors.New(brokerErrorOverrideOnMessage)
}
