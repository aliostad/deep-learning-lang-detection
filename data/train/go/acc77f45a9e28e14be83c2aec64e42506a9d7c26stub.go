package stub_broker

import (
	"errors"
	"github.com/plimble/kuja/broker"
)

type stubBroker struct {
	handlers map[string]map[string]broker.Handler
}

func NewBroker() *stubBroker {
	return &stubBroker{
		handlers: make(map[string]map[string]broker.Handler),
	}
}

func (s *stubBroker) Connect() error {
	return nil
}

func (s *stubBroker) Close() {
}

func (s *stubBroker) Publish(topic string, msg *broker.Message) error {

	if _, ok := s.handlers[topic]; !ok {
		return errors.New("topic not found")
	}

	for _, handler := range s.handlers[topic] {
		if _, err := handler(topic, msg); err != nil {
			return err
		}
	}

	return nil
}

func (s *stubBroker) Subscribe(topic, queue, appId string, size int, h broker.Handler) {
	if _, ok := s.handlers[topic]; !ok {
		s.handlers[topic] = make(map[string]broker.Handler)
	}

	s.handlers[topic][queue] = h
}
