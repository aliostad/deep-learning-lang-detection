package transfer

import (
	"github.com/ineiti/cybermind/broker"
)

/*
The server-module allows for connections to a static IP and handles
selective sending and receiving of messages.
*/

type Server struct {
	Path          string
	AccessControl []AccessControl
}

type AccessControl struct {
}

func RegisterServer(b *broker.Broker) error {
	return b.RegisterModule("server", NewServer)
}

func NewServer(b *broker.Broker, config []byte) broker.Module {
	return &Server{}
}

func (s *Server) ProcessMessage(m *broker.Message) ([]broker.Message, error) {
	return nil, nil
}
