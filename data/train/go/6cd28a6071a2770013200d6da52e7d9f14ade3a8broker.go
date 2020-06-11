package apiserver

import (
	"context"
	"dmexe.me/utils"
	"github.com/Sirupsen/logrus"
	"sync"
	"time"
)

// Broker keeps listeners and broadcast messages,
// https://gist.github.com/schmohlio/d7bdb255ba61d3f5e51a512a7c0d6a85#file-sse-go-L50
type Broker struct {
	// Events are pushed to this channel by the main events-gathering routine
	notifier chan BrokerEvent

	// New client connections
	newClients chan chan BrokerEvent

	// Closed client connections
	closingClients chan chan BrokerEvent

	// Client connections registry
	clients map[chan BrokerEvent]bool

	log *logrus.Entry
	ctx context.Context
}

// BrokerEvent contains event payload
type BrokerEvent struct {
	Name string
	Data []byte
}

// NewBroker creates a new broker instance using context
func NewBroker(ctx context.Context) *Broker {
	return &Broker{
		notifier:       make(chan BrokerEvent, 1),
		newClients:     make(chan chan BrokerEvent, 1),
		closingClients: make(chan chan BrokerEvent, 1),
		clients:        make(map[chan BrokerEvent]bool),
		log:            utils.NewLogEntry("api.broker"),
		ctx:            ctx,
	}
}

// Notify broadcasts bytes to all clients
func (b *Broker) Notify(evt BrokerEvent) {
	b.notifier <- evt
}

// Add a new client
func (b *Broker) Add(client chan BrokerEvent) {
	b.newClients <- client
}

// Remove client
func (b *Broker) Remove(client chan BrokerEvent) {
	b.closingClients <- client
}

func (b *Broker) length() int {
	return len(b.clients)
}

// Run starts broker
func (b *Broker) Run(wg *sync.WaitGroup) error {
	wg.Add(1)

	go func() {
		defer wg.Done()

		for {
			select {
			case <-b.ctx.Done():
				b.log.Debug("Context done")
				return

			case s := <-b.newClients:
				b.clients[s] = true
				b.log.Debugf("Client added. %d registered clients", b.length())

			case s := <-b.closingClients:
				delete(b.clients, s)
				b.log.Debugf("Client removed. %d registered clients", b.length())

			case event := <-b.notifier:
				for clientMessageChan := range b.clients {
					select {
					case clientMessageChan <- event:
					case <-time.After(time.Second):
						b.log.Warn("Skipping client")
					}
				}
			}
		}
	}()

	b.log.Debugf("Broker started")

	return nil
}
