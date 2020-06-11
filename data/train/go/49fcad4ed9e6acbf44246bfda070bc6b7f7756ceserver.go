package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

import _ "net/http/pprof"

type Broker struct {
	Push   chan []byte
	subs   chan chan []byte
	unsubs chan chan []byte
}

func NewServer() *Broker {
	broker := &Broker{
		Push:   make(chan []byte, 1),
		subs:   make(chan chan []byte),
		unsubs: make(chan chan []byte),
	}
	go broker.listen()
	return broker
}

func (broker *Broker) ServeHTTP(rw http.ResponseWriter, req *http.Request) {
	rw.Header().Set("Content-Type", "text/event-stream")
	rw.Header().Set("Cache-Control", "no-cache")
	rw.Header().Set("Connection", "keep-alive")

	notify := rw.(http.CloseNotifier).CloseNotify()
	ch := make(chan []byte)
	broker.subs <- ch
	defer func() {
		broker.unsubs <- ch
	}()

	for {
		select {
		case <-notify:
			return
		case m, ok := <-ch:
			if !ok {
				return
			}
			fmt.Fprintf(rw, "data: %s\n\n", m)
			rw.(http.Flusher).Flush()
		}
	}
}

func (broker *Broker) listen() {
	clients := map[chan []byte]struct{}{}
	for {
		select {
		case s := <-broker.subs:
			clients[s] = struct{}{}
		case s := <-broker.unsubs:
			delete(clients, s)
			close(s)
		case event := <-broker.Push:
			for clientMessageChan, _ := range clients {
				clientMessageChan <- event
			}
		}
	}
}

func main() {
	broker := NewServer()
	go func() {
		for {
			time.Sleep(time.Second * 2)
			broker.Push <- []byte(time.Now().String())
		}
	}()
	http.Handle("/sse", broker)
	http.Handle("/", http.FileServer(http.Dir(".")))
	if err := http.ListenAndServe("localhost:3000", nil); err != nil {
		log.Fatal("HTTP server error: ", err)
	}
}
