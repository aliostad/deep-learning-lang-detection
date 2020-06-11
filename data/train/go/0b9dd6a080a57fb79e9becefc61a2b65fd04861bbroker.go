package pubsub

import (
	"github.com/grosunick/go-common/core"
	"sync"
	"time"
)

// PubSub broker. Base opportunities:
// -- creating subscribe channel
// -- removing subscribe channel

// PubSub broker props struct
type BrokerProps struct {
	// Cleanin period of unused channels (seconds)
	CleanPeriod uint32
	// Maximum life time of channel without subscribers (seconds).
	// If LifeTimeWithoutSubscribers is 0 the channel exists infinitely.
	LifeTimeWithoutSubscribers uint32
}

// PubSub broker struct
type Broker struct {
	// Map contains all channels
	channels map[string]IChannel
	// Mutex
	locker sync.RWMutex
	// PubSub broker props
	props *BrokerProps
}

// PubSub broker factory
func NewBroker(props *BrokerProps) *Broker {
	broker := &Broker{
		make(map[string]IChannel),
		sync.RWMutex{},
		props,
	}

	return broker
}

// Creates channel with name 'name' and properties 'props'
func (this *Broker) CreateChannel(name string, props *ChannelProps) IChannel {
	channel := NewChannel(props, this)

	this.locker.Lock()
	this.channels[name] = channel
	this.locker.Unlock()

	channel.Observe()

	return channel
}

// Returns channel object by his name.
func (this *Broker) GetChannel(name string) (channel IChannel, res bool) {
	this.locker.RLock()
	defer this.locker.RUnlock()

	channel, res = this.channels[name]

	return
}

// Removes channel
func (this *Broker) DeleteChannel(name string) (bool, error) {
	this.locker.Lock()
	defer this.locker.Unlock()

	if _, ok := this.channels[name]; !ok {
		return false, &core.Error{ERROR_CHANNEL_NOT_EXISTS, "channel" + name + "doesn't exists"}
	}

	delete(this.channels, name)
	return true, nil
}

// Runs pubsub broker
func (this *Broker) Run() {
	go this.clean()
}

// Removes unused channels
func (this *Broker) clean() {
	for {
		select {
		case <-time.NewTicker(time.Second * time.Duration(this.props.CleanPeriod)).C:
			channelsForDelete := make(map[string]bool)

			// detects names of unused channels
			this.locker.RLock()
			for name, channel := range this.channels {
				if channel.GetSubscribers().CanRemoveChannel(this.props) {
					channelsForDelete[name] = true
				}
			}
			this.locker.RUnlock()

			for name, _ := range channelsForDelete {
				this.DeleteChannel(name)
			}
		}
	}
}
