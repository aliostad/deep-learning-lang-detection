package todoeventstream

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

type Broker struct {
	Notifier chan []byte

	//New Client connections
	newClients chan chan []byte

	//Closed client connections
	closingClients chan chan []byte

	//Client connections registry
	clients map[chan []byte]bool
}

func NewServer()(broker *Broker) {
	broker = &Broker{
		Notifier: make(chan []byte, 1),
		newClients: make(chan chan []byte),
		closingClients: make(chan chan []byte),
		clients: make(map[chan []byte]bool),
	}

	//Set the broker running
	go broker.listen()
	return
}

func (broker *Broker) ServeHTTP(rw http.ResponseWriter, req *http.Request){
	//Make sure that the client supports flushing, if not they do not support event stream
	flusher, ok := rw.(http.Flusher)

	if !ok {
		http.Error(rw, "Streaming unsupported!", http.StatusInternalServerError)
		return
	}

	rw.Header().Set("Content-Type", "text/event-stream")
	rw.Header().Set("Cache-Control", "no-cache")
	rw.Header().Set("Connection", "keep-alive")
	rw.Header().Set("Access-Control-Allow-Origin", "*")

	messageChan := make(chan []byte)

	broker.newClients <- messageChan
	defer func() {
		broker.closingClients <- messageChan
	}()

	notify := rw.(http.CloseNotifier).CloseNotify()

	go func() {
		<- notify
		broker.closingClients <- messageChan
	}()

	for {
		fmt.Fprintf(rw, "data: %s\n\n", <- messageChan)
		flusher.Flush()
	}

}

func (broker *Broker) listen()  {
	for {
		select {
		case s := <- broker.newClients:
			broker.clients[s] = true
			log.Printf("Client added. %d registered clients", len(broker.clients))
		case s := <- broker.closingClients:
			delete(broker.clients, s)
			log.Printf("Removed client. %d registered clients", len(broker.clients))
		case event := <- broker.Notifier:
			//Send new event
			for clientMessageChan, _ := range broker.clients{
				clientMessageChan <- event
			}

		}
	}
}

func (broker *Broker) StartDemo()  {
	go func() {
		for {
			time.Sleep(time.Second * 2)
			eventString := fmt.Sprintf("the time is %v", time.Now())
			broker.Notifier <- []byte(eventString)
		}
	}()
}