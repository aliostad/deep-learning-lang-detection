package gobroker

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"net"
	"strings"
	"sync"
	"time"
)

//-----------------------------------------------------------------------------
// Topic
//-----------------------------------------------------------------------------

type topic struct {
	name           string             // topic name
	lifecycle_ch   chan int           // For terminating the processing loop
	incoming_ch    chan []byte        // Messages to send to subscribers
	subscribe_ch   chan *brokerClient // Subscribe a client to the topic
	unsubscribe_ch chan *brokerClient // Remove client from subscribers
	subscribers    []*brokerClient    // Current subscribers
}

func newTopic(name string) *topic {
	return &topic{
		name:           name,
		incoming_ch:    make(chan []byte),
		subscribe_ch:   make(chan *brokerClient),
		unsubscribe_ch: make(chan *brokerClient),
		subscribers:    make([]*brokerClient, 0),
	}
}

func (topic *topic) process() {
	go func() {
		for {
			select {

			case <-topic.lifecycle_ch:
				return

			case msg := <-topic.incoming_ch:
				log.Println("topic.incoming")
				num_subs := len(topic.subscribers)
				if num_subs != 0 {
					for _, client := range topic.subscribers {
						client.publish(msg)
					}
				}

			case client := <-topic.subscribe_ch:
				log.Println("[topic] subscribe")
				topic.subscribers = append(topic.subscribers, client)

			case client := <-topic.unsubscribe_ch:
				clients := make([]*brokerClient, 0)
				for _, subscriber := range topic.subscribers {
					if client != subscriber {
						clients = append(clients, subscriber)
					}
				}
				topic.subscribers = clients
			}
		}
	}()
}

func (topic *topic) subscribe(client *brokerClient) {
	topic.subscribe_ch <- client
}

func (topic *topic) unsubscribe(client *brokerClient) {
	topic.unsubscribe_ch <- client
}

func (topic *topic) publish(msg []byte) {
	topic.incoming_ch <- msg
}

func (topic *topic) start() {
	topic.lifecycle_ch = make(chan int)
	topic.process()
}

func (topic *topic) stop() {
	close(topic.lifecycle_ch) // Will send default value (0)
}

//-----------------------------------------------------------------------------
// Client
//-----------------------------------------------------------------------------

func (client *brokerClient) read() {
	go func() {
		for {
			message, err := DecodeMessage(client.reader)
			if err != nil {
				if err == io.EOF {
					log.Printf("EOF on read()")
					break
				}
				log.Printf("Error: %v\n", err)
				break
			}
			client.incoming_ch <- message
		}
		client.stop()
	}()
}

func (client *brokerClient) ack() {
	log.Println("[client] sending ack")
	ack, err := NewAckMessage().Encode()
	if err != nil {
		log.Println("Error on ack()", err)
	}
	client.publish(ack)
}

func (client *brokerClient) process() {

	go func() {
		for {
			select {

			case _ = <-client.lifecycle_ch:
				return

			case msg := <-client.incoming_ch:
				client.dispatcher.dispatch(client, msg)
			}
		}
	}()
}

func (client *brokerClient) publish(msg []byte) {

	client.writeLock.Lock()
	defer client.writeLock.Unlock()

	log.Println("[client] publishing msg")
	_, err := client.writer.Write(msg)
	if err != nil {
		log.Println("ERROR: publish.write()", err)
		return
	}

	err = client.writer.Flush()
	if err != nil {
		log.Println("ERROR: publish.flush()", err)
	}
}

func (client *brokerClient) start() {
	log.Println(" - starting client", client.conn.RemoteAddr())
	client.reader = bufio.NewReader(client.conn)
	client.writer = bufio.NewWriter(client.conn)
	client.process()
	client.read()
}

func (client *brokerClient) stop() {
	log.Println(" - stopping client", client.conn.RemoteAddr())
	close(client.lifecycle_ch)
	client.dispatcher.disconnect(client)
}

type brokerClient struct {
	conn         net.Conn // Socket
	reader       *bufio.Reader
	writer       *bufio.Writer
	writeLock    sync.Mutex
	dispatcher   *Broker      // Hub
	lifecycle_ch chan int     // Client lifecycle
	incoming_ch  chan Message // Data coming in from the network
}

func newBrokerClient(conn net.Conn, dispatcher *Broker) *brokerClient {
	return &brokerClient{
		conn:         conn,
		dispatcher:   dispatcher,
		lifecycle_ch: make(chan int),
		incoming_ch:  make(chan Message),
	}
}

//-----------------------------------------------------------------------------
// Broker
//-----------------------------------------------------------------------------

func (broker *Broker) accept() {
	go func() {
		for {
			conn, err := broker.listener.Accept()
			if err == nil {
				broker.accept_ch <- conn
			} else {
				if strings.Contains(err.Error(), "closed network") {
					log.Println(" - shutting down listener.")
				} else {
					log.Println(" - listener/accept error ->", err.Error())
				}
				return
			}
		}
	}()
}

func (broker *Broker) dispatch(client *brokerClient, msg Message) {

	switch msg.Code {

	case BrokerPubMessage:
		broker.publish_ch <- pubEvent{client, msg}

	case BrokerSubMessage:
		broker.subscribe_ch <- subEvent{client, msg.Topic}

	case BrokerUnsubMessage:
		log.Println(" - unsubscribe not implemented")
		client.ack()
	}
}

func (broker *Broker) disconnect(client *brokerClient) {
	broker.delete_ch <- client
}

func (broker *Broker) processLoop() {
	go func() {
		for {
			select {

			case <-broker.lifecycle_ch:
				return

			case conn := <-broker.accept_ch:
				broker.handleAccept(conn)

			case event := <-broker.publish_ch:
				broker.handlePublish(event)

			case event := <-broker.subscribe_ch:
				broker.handleSubscribe(event)

			case client := <-broker.delete_ch:
				broker.handleDelete(client)
			}
		}
	}()
}

func (broker *Broker) handleAccept(conn net.Conn) {
	client := newBrokerClient(conn, broker)
	broker.clients = append(broker.clients, client)
	client.start()
}

func (broker *Broker) handlePublish(event pubEvent) {
	name := event.message.Topic
	if topic := broker.topics[name]; topic != nil {
		msg, err := event.message.Encode()
		if err != nil {
			log.Println("Error: unable to encode msg for delivery.", msg)
		}
		topic.publish(msg)
	}
	log.Println("[broker] publick ack")
	event.client.ack()
}

func (broker *Broker) handleSubscribe(event subEvent) {
	var name = event.topic
	var topic *topic

	topic, ok := broker.topics[name]
	if !ok {
		topic = newTopic(name)
		topic.start()
		broker.topics[name] = topic
	}
	topic.subscribe(event.client)
	log.Println("[broker] subscribe ack")
	event.client.ack()
}

func (broker *Broker) handleDelete(client *brokerClient) {
	for _, topic := range broker.topics {
		topic.unsubscribe(client)
	}

	newClients := make([]*brokerClient, 0)

	for _, item := range broker.clients {
		if item == client {
			continue
		}
		newClients = append(newClients, item)
	}

	broker.clients = newClients
}

func (broker *Broker) Start() error {
	log.Println("Starting broker.")
	l, err := net.Listen("tcp", fmt.Sprintf(":%d", broker.port))
	if err != nil {
		return err
	}
	broker.listener = l
	broker.accept()
	broker.processLoop()

	// TODO: This should not return until the accept and process
	//       loops are fully engaged (that is, if we want to use
	//       this stuff in a tight test loop).
	time.Sleep(1 * time.Second)
	return nil
}

func (broker *Broker) Stop() {
	log.Println("Stopping broker.")
	if broker.listener != nil {
		broker.listener.Close()
	} else {
		fmt.Println(" *** LISTENER IS NIL")
	}
}

type pubEvent struct {
	client  *brokerClient
	message Message
}

type subEvent struct {
	client *brokerClient
	topic  string
}

type Broker struct {
	listener     net.Listener
	port         int
	clients      []*brokerClient
	topics       map[string]*topic
	accept_ch    chan net.Conn
	delete_ch    chan *brokerClient
	publish_ch   chan pubEvent
	subscribe_ch chan subEvent
	lifecycle_ch chan struct{}
}

func NewBroker(port int) *Broker {
	return &Broker{
		port:         port,
		clients:      make([]*brokerClient, 0),
		topics:       make(map[string]*topic),
		accept_ch:    make(chan net.Conn),      // incoming client connections
		delete_ch:    make(chan *brokerClient), // dropped client connections
		publish_ch:   make(chan pubEvent),
		subscribe_ch: make(chan subEvent),
	}
}
