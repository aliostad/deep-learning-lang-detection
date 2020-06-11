package broker

import (
	"producer"
	"consumer"
	"sync"
)

type Broker struct {
	producers	map[string]*producer.Producer
	consumers	map[string]*consumer.Consumer
	consumerMutex	sync.Mutex
}

func NewBroker() *Broker {
	return &Broker{
		producers: make(map[string]*producer.Producer),
		consumers: make(map[string]*consumer.Consumer),
	}
}

func (b *Broker)Produce(topic string, data []byte) {
	if _, ok := b.producers[topic]; !ok {
		b.producers[topic] = producer.NewProducer(topic)
	}
	b.producers[topic].Produce(data)
}

func (b *Broker)Consume(topic string, pos int64) []byte {
	b.consumerMutex.Lock()
	if _, ok := b.consumers[topic]; !ok {
		b.consumers[topic] = consumer.NewConsumer(topic)
	}
	b.consumerMutex.Unlock()
	return b.consumers[topic].Consume(pos)
}