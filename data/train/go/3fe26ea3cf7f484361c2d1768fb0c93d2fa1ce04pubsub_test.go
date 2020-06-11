package main

import (
	"errors"
	"testing"
	"time"
)

type StubPeer struct {
	msgsReceived []Msg
}

func (p *StubPeer) Deliver(m Msg) {
	p.msgsReceived = append(p.msgsReceived, m)
}

func (p *StubPeer) Connect(stream LineStream, broker Dispatcher) {}

func NewStubPeer() *StubPeer {
	return &StubPeer{msgsReceived: make([]Msg, 0)}
}

func TestBrokerSubscribeAndDisconnect(t *testing.T) {
	peer := NewStubPeer()
	broker := NewBroker()
	go broker.Run()
	broker.Subscribe(Subscription{client: peer, topic: "hi"})
	_, exists := broker.topics["hi"][peer]
	if !exists {
		t.Error("Subscription not created")
	}

	broker.Disconnect(peer)
	time.Sleep(10000)
	_, exists = broker.topics["hi"][peer]
	if exists {
		t.Error("Unsubscribing failed")
	}
}

func TestBrokerDeliversMessages(t *testing.T) {
	peer := NewStubPeer()
	peer2 := NewStubPeer()
	message := &Msg{topic: "hi", body: "test"}
	broker := NewBroker()
	go broker.Run()
	broker.Subscribe(Subscription{client: peer, topic: "hi"})
	broker.Subscribe(Subscription{client: peer2, topic: "hi"})
	broker.Broadcast(*message)
	for len(peer.msgsReceived) < 1 {
		time.Sleep(5)
	}
	if peer.msgsReceived[0] != *message {
		t.Fail()
	}
	if peer2.msgsReceived[0] != *message {
		t.Fail()
	}
}

func TestMessageParsing(t *testing.T) {
	peer := Peer{}
	m, mok := peer.ParseLine("topic:i'm a message").(Msg)
	s, sok := peer.ParseLine("i'm a topic subscription").(Subscription)
	if !mok || !sok {
		t.Fail()
	}
	if !(m == Msg{topic: "topic", body: "i'm a message"}) {
		t.Fail()
	}
	if !(s == Subscription{topic: "i'm a topic subscription", client: &peer}) {
		t.Fail()
	}
}

type MockStream struct {
	linesToSend  chan string
	linesWritten chan string
}

func NewMockStream() *MockStream {
	return &MockStream{linesToSend: make(chan string, 5), linesWritten: make(chan string, 5)}
}

func (m *MockStream) ReadLine() (string, error) {
	return <-m.linesToSend, nil
}

func (m *MockStream) WriteLine(line string) error {
	select {
	case m.linesWritten <- line:
		return nil
	default:
		return errors.New("Could not write line!")
	}
}

func TestPeerBroadcastsMessage(t *testing.T) {
	peer := NewPeer()
	stream := NewMockStream()
	broker := NewBroker()
	go broker.Run()
	peer.Connect(stream, broker)
	stream.linesToSend <- "topic"         // subscription
	stream.linesToSend <- "topic:message" // broadcast
	result := <-stream.linesWritten
	if result != "topic:message" { // peer has received this message from itself
		t.Fail()
	}
}
