package user

import (
	"github.com/ineiti/cybermind/broker"
)

/*
This module offers a web-server where the user can connect to and configure
the cybermind and interact with it.
*/
type Web struct {
}

func RegisterWeb(b *broker.Broker) error {
	err := b.RegisterModule("web", NewWeb)
	if err != nil {
		return err
	}
	return b.SpawnModule("web", nil)
}

func NewWeb(b *broker.Broker, config []byte) broker.Module {
	return &Web{}
}

func (w *Web) ProcessMessage(m *broker.Message) ([]broker.Message, error) {
	return nil, nil
}
