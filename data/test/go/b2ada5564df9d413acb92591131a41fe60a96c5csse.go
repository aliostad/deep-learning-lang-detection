package sse

import (
	"fmt"
	"log"
	"time"
	"bufio"
	"github.com/valyala/fasthttp"
)

// the amount of time to wait when pushing a message to
// a slow client or a client that closed after `range clients` started.
const patience time.Duration = time.Second*1

type Broker struct {
	Notifier chan []byte
	newClients chan chan []byte
	closingClients chan chan []byte
	clients map[chan []byte]byte

}

func NewSSE() (broker *Broker) {
	broker = &Broker{
		Notifier:       make(chan []byte, 1),
		newClients:     make(chan chan []byte),
		closingClients: make(chan chan []byte),
		clients:        make(map[chan []byte]byte),
	}
	go broker.listen()
	return
}

func (broker *Broker) ServeHTTP(ctx *fasthttp.RequestCtx) {
	ctx.SetContentType("text/event-stream")
	ctx.Response.Header.Set("Cache-Control", "no-cache")
	ctx.Response.Header.Set("Connection", "keep-alive")
	ctx.Response.Header.Set("Access-Control-Allow-Origin", "*")

	ctx.SetBodyStreamWriter(func(w *bufio.Writer) {
		messageChan := make(chan []byte)
		broker.newClients <- messageChan
		defer func() {
			broker.closingClients <- messageChan
			close(messageChan)
		}()

		for {
				fmt.Fprintf(w, "data: %s\n\n", <-messageChan)

				// Flush the data immediatly instead of buffering it for later.
				if err := w.Flush(); err != nil {
					log.Printf("Flush error %s", err)
					return
				}
			}
	})
	log.Printf("Out from http")
}

func (broker *Broker) HasClients() (bool) {
	return len(broker.clients) > 0
}

func (broker *Broker) listen() {
	for {
		select {
		case s := <-broker.newClients:
			broker.clients[s] = 1
			log.Printf("Client added. %d registered clients", len(broker.clients))
		
		case s := <-broker.closingClients:
			delete(broker.clients, s)
			log.Printf("Removed client. %d registered clients", len(broker.clients))
		
		case event := <-broker.Notifier:
			for clientMessageChan, _ := range broker.clients {
				select {
				case clientMessageChan <- event:
				case <-time.After(patience):
					log.Print("Skipping client.")
				}
			}
		}
	}

}