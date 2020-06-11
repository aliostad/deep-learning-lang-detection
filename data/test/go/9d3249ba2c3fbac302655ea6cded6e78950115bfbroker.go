package common

import (
	"log"
)

type Broker struct {
	clients map[chan []byte]bool
	add     chan chan []byte
	del     chan chan []byte
	event   chan []byte
}

func NewBroker() (broker *Broker) {
	broker = &Broker{
		event:   make(chan []byte),
		clients: make(map[chan []byte]bool),
		add:     make(chan chan []byte),
		del:     make(chan chan []byte),
	}
	go broker.Listen()
	return
}

func (b *Broker) Add(messageChan chan []byte) {
	b.add <- messageChan
}

func (b *Broker) Delete(messageChan chan []byte) {
	b.del <- messageChan
}

func (b *Broker) Event(message []byte) {
	b.event <- message
}

func (b *Broker) Listen() {
	for {
		select {
		case client := <-b.add:
			b.clients[client] = true
			log.Println("Connect new client: (", len(b.clients), ")")
		case client := <-b.del:
			delete(b.clients, client)
			log.Println("Disconnect client: (", len(b.clients), ")")
		case event := <-b.event:
			for toClientMessage, _ := range b.clients {
				toClientMessage <- event
			}
		}
	}
}
