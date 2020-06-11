package nats

import (
	"github.com/apcera/nats"
	"github.com/plimble/kuja/broker"
)

type natsBroker struct {
	url  string
	conn *nats.Conn
}

func NewBroker(url string) *natsBroker {
	return &natsBroker{
		url: url,
	}
}

func (n *natsBroker) Connect() error {
	var err error
	n.conn, err = nats.Connect(n.url)

	return err
}

func (n *natsBroker) Close() {
	n.conn.Close()
}

func (n *natsBroker) Publish(topic string, msg *broker.Message) error {
	data, err := msg.Marshal()
	if err != nil {
		return err
	}
	return n.conn.Publish(topic, data)
}

func (n *natsBroker) Subscribe(topic, queue, appId string, size int, h broker.Handler) {
	for i := 0; i < size; i++ {
		n.conn.QueueSubscribe(topic, queue, func(msg *nats.Msg) {
			brokerMsg := &broker.Message{}
			brokerMsg.Unmarshal(msg.Data)
			retryCount, err := h(msg.Subject, brokerMsg)
			if err != nil {
				for i := 0; i < retryCount; i++ {
					brokerMsg.Retry++
					_, err := h(topic, brokerMsg)
					if err == nil {
						break
					}
				}
			}
		})
	}
}
