package sphere

import (
	"github.com/gorilla/websocket"
	redis "gopkg.in/redis.v3"
)

var (
	roption = redis.Options{
		Addr:     "localhost:6379",
		Password: "",
		DB:       0,
	}
	pubclient = redis.NewClient(&roption)
	subclient = redis.NewClient(&roption)
)

// DefaultRedisBroker creates a new instance of RedisBroker
func DefaultRedisBroker() *RedisBroker {
	return &RedisBroker{
		ExtendBroker(),
	}
}

// RedisBroker is a broker adapter built on Redis client
type RedisBroker struct {
	*Broker
}

// OnSubscribe when websocket subscribes to a channel
func (broker *RedisBroker) OnSubscribe(channel *Channel, done chan<- IError) {
	go func() {
		// return if pubsub is already existed
		if broker.store.Has(channel.Name()) {
			done <- nil
			return
		}
		// creates subscribe pubsub
		pubsub, err := subclient.Subscribe(channel.Name())
		if err == nil {
			broker.store.Set(channel.Name(), pubsub)
		}
		done <- err
		for {
			msg, err := pubsub.ReceiveMessage()
			if err != nil {
				done <- err
				return
			}
			if p, err := ParsePacket([]byte(msg.Payload)); err == nil {
				broker.OnMessage(channel, p)
			}
		}
	}()
}

// OnUnsubscribe when websocket unsubscribes from a channel
func (broker *RedisBroker) OnUnsubscribe(channel *Channel, done chan<- IError) {
	go func() {
		if tmp, ok := broker.store.Get(channel.Name()); ok {
			if pubsub, ok := tmp.(*redis.PubSub); ok {
				// close pubsub handler
				done <- pubsub.Close()
				// remove pubsub from store
				broker.store.Remove(channel.Name())
			}
		} else {
			done <- nil
		}
	}()
}

// OnPublish when websocket publishes data to a particular channel from the current broker
func (broker *RedisBroker) OnPublish(channel *Channel, data *Packet) error {
	c := make(chan error)
	go func() {
		if str := data.String(); str != "" {
			res := pubclient.Publish(channel.Name(), str)
			c <- res.Err()
		} else {
			c <- nil
		}
	}()
	return <-c
}

// OnMessage when websocket receive data from the broker subscriber
func (broker *RedisBroker) OnMessage(channel *Channel, data *Packet) error {
	c := make(chan error)
	go func() {
		if json, err := data.ToJSON(); err == nil {
			channel.Emit(websocket.TextMessage, json, nil)
		}
		c <- nil
	}()
	return <-c
}
