package notification

import (
	"github.com/blent/beagle/src/core/discovery/peripherals"
	"github.com/blent/beagle/src/core/tracking"
	"go.uber.org/zap"
)

type (
	BrokerEventHandler func(peripheral peripherals.Peripheral, registered bool)

	TargetRegistry func(key string) (*tracking.Peripheral, error)

	SubscriberRegistry func(targetId uint64, events ...string) ([]*Subscriber, error)

	EventBroker struct {
		logger      *zap.Logger
		sender      *Sender
		targets     TargetRegistry
		subscribers SubscriberRegistry
		handlers    map[string][]BrokerEventHandler
	}
)

func NewEventBroker(logger *zap.Logger, sender *Sender, targets TargetRegistry, subscribers SubscriberRegistry) *EventBroker {
	return &EventBroker{
		logger,
		sender,
		targets,
		subscribers,
		make(map[string][]BrokerEventHandler),
	}
}

func (broker *EventBroker) Use(stream *tracking.Stream) {
	go broker.doUse(stream)
}

func (broker *EventBroker) Subscribe(eventName string, handler BrokerEventHandler) {
	if handler != nil {
		event := broker.handlers[eventName]

		if event == nil {
			event = make([]BrokerEventHandler, 0, 10)
		}

		broker.handlers[eventName] = append(event, handler)
	}
}

func (broker *EventBroker) doUse(stream *tracking.Stream) {
	streamIsClosed := false

	for {
		if streamIsClosed {
			broker.logger.Info("Stream is closed")
			return
		}

		select {
		case peripheral, isOpen := <-stream.Found():
			if isOpen {
				broker.notify(PERIPHERAL_FOUND, peripheral)
			}

			streamIsClosed = !isOpen
		case peripheral, isOpen := <-stream.Lost():
			if isOpen {
				broker.notify(PERIPHERAL_LOST, peripheral)
			}

			streamIsClosed = !isOpen
		case err, _ := <-stream.Error():
			streamIsClosed = true

			broker.logger.Error(
				"Error occurred during consuming the stream",
				zap.Error(err),
			)
		}
	}
}

func (broker *EventBroker) notify(eventName string, peripheral peripherals.Peripheral) {
	go func() {
		key := peripheral.UniqueKey()

		if key == "" {
			broker.logger.Error("Peripheral contains an empty key")
			return
		}

		found, err := broker.targets(key)

		if err != nil {
			broker.emit(eventName, peripheral, false)
			broker.logger.Error(
				"Failed to retrieve a peripheral",
				zap.String("key", key),
				zap.Error(err),
			)

			return
		}

		broker.emit(eventName, peripheral, found != nil)

		if found == nil {
			broker.logger.Info(
				"Peripheral is not registered",
				zap.String("key", key),
			)

			return
		}

		if found.Enabled == false {
			broker.logger.Info(
				"Peripheral is disabled",
				zap.String("key", key),
			)

			return
		}

		subscribers, err := broker.subscribers(found.Id, eventName, "*")

		if subscribers == nil || len(subscribers) == 0 {
			broker.logger.Info(
				"Peripheral does not have any enabled subscribers",
				zap.String("key", key),
			)
			return
		}

		broker.sender.Send(NewMessage(eventName, found.Name, peripheral, subscribers))
	}()
}

func (broker *EventBroker) emit(eventName string, peripheral peripherals.Peripheral, registered bool) {
	go func() {
		event := broker.handlers[eventName]

		if event != nil {
			for _, handler := range event {
				handler(peripheral, registered)
			}
		}
	}()
}
