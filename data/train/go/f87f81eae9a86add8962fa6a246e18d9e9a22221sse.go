/*
   This SSE broker taken from @schmohlio with a few changes:
     https://gist.github.com/schmohlio/d7bdb255ba61d3f5e51a512a7c0d6a85
*/
package web

import (
	"fmt"
	"net/http"
	"time"
)

// the amount of time to wait when pushing a message to
// a slow client or a client that closed after `range clients` started.
const patience time.Duration = time.Second * 1

type Broker struct {

	// Events are pushed to this channel by the main events-gathering routine
	Notifier chan []byte

	// New client connections
	newClients chan chan []byte

	// Closed client connections
	closingClients chan chan []byte

	// Client connections registry
	clients map[chan []byte]bool

	// Stop broker
	done chan struct{}
}

func NewServer() (broker *Broker) {
	// Instantiate a broker
	broker = &Broker{
		Notifier:       make(chan []byte, 1),
		newClients:     make(chan chan []byte),
		closingClients: make(chan chan []byte),
		clients:        make(map[chan []byte]bool),
		done:           make(chan struct{}),
	}

	// Set it running - listening and broadcasting events
	go broker.listen()

	return
}

//func (broker *Broker) ServeHTTP(rw http.ResponseWriter, req *http.Request) {
func (broker *Broker) statHandler(rw http.ResponseWriter, req *http.Request) {
	// Make sure that the writer supports flushing.
	//
	flusher, ok := rw.(http.Flusher)

	if !ok {
		http.Error(rw, "Streaming unsupported!", http.StatusInternalServerError)
		return
	}

	rw.Header().Set("Content-Type", "text/event-stream")
	rw.Header().Set("Cache-Control", "no-cache")
	rw.Header().Set("Connection", "keep-alive")
	rw.Header().Set("Access-Control-Allow-Origin", "*")

	// Each connection registers its own message channel with the Broker's connections registry
	messageChan := make(chan []byte)

	// Signal the broker that we have a new connection
	broker.newClients <- messageChan

	// Remove this client from the map of connected clients
	// when this handler exits.
	defer func() {
		broker.closingClients <- messageChan
	}()

	// Listen to connection close and un-register messageChan
	notify := rw.(http.CloseNotifier).CloseNotify()

	// fixed by @schmohlio
	// closing a client twice
	for {
		select {
		case <-notify:
			return
		default:
			// Write to the ResponseWriter
			// Server Sent Events compatible
			fmt.Fprintf(rw, "data: %s\n\n", <-messageChan)

			// Flush the data immediatly instead of buffering it for later.
			flusher.Flush()
		}
	}
}

func (broker *Broker) listen() {
	for {
		select {
		case s := <-broker.newClients:

			// A new client has connected.
			// Register their message channel
			broker.clients[s] = true
		case s := <-broker.closingClients:

			// A client has dettached and we want to
			// stop sending them messages.
			delete(broker.clients, s)
		case event := <-broker.Notifier:

			// We got a new event from the outside!
			// Send event to all connected clients
			for clientMessageChan, _ := range broker.clients {

				// fixed by @schmohlio
				// potentially blocked listen() from closing a connection during multiplex step.
				select {
				case clientMessageChan <- event:
				case <-time.After(patience):
				}
			}
		case _, ok := <-broker.done:
			if !ok {
				return
			}
		}
	}

}

func (broker *Broker) Stop() {
	close(broker.done)
}
