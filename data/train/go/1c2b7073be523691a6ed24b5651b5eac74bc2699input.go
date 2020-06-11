package test

import (
	"github.com/ineiti/cybermind/broker"
	"gopkg.in/dedis/onet.v1/log"
)

const ModuleTestInput = "testInput"

type TestInput struct {
	Broker *broker.Broker
}

func RegisterTestInput(b *broker.Broker) error {
	return b.RegisterModule(ModuleTestInput, NewTestInput)
}

func NewTestInput(b *broker.Broker, id broker.ModuleID, msg *broker.Message) broker.Module {
	return &TestInput{
		Broker: b,
	}
}

func (t *TestInput) ProcessMessage(m *broker.Message) ([]broker.Message, error) {
	log.Lvl3("got message", m)
	return nil, nil
}
