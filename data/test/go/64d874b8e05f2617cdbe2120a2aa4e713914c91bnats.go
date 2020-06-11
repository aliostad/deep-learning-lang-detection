package nats

import (
	"log"
	"os"

	"github.com/moonwalker/margaret/broker"
	"github.com/nats-io/nats"
)

type natsBroker struct {
	conn *nats.Conn
}

func NewBroker() broker.Broker {
	natsURL, ok := os.LookupEnv("NATS")
	if !ok {
		natsURL = nats.DefaultURL
	}

	b := &natsBroker{}

	var err error
	b.conn, err = nats.Connect(natsURL)

	if err != nil {
		log.Fatal(err)
	}

	return b
}

func (b *natsBroker) String() string {
	return "nats"
}

func (b *natsBroker) Connect() error {
	return b.conn.Flush()
}

func (b *natsBroker) Disconnect() error {
	b.conn.Close()
	return nil
}

func (b *natsBroker) Publish(subject string, data []byte) error {
	return b.conn.Publish(subject, data)
}

func (b *natsBroker) Subscribe(subject string, handler func([]byte), opts ...broker.SubscribeOption) error {
	opt := &broker.SubscribeOptions{}
	for _, o := range opts {
		o(opt)
	}

	fn := func(msg *nats.Msg) {
		handler(msg.Data)
	}

	var err error
	if len(opt.Queue) > 0 {
		_, err = b.conn.QueueSubscribe(subject, opt.Queue, fn)
	} else {
		_, err = b.conn.Subscribe(subject, fn)
	}

	return err
}
