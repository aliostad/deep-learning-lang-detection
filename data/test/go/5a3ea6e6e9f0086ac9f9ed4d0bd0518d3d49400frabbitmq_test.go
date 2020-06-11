package rabbitmq_test

import (
	"testing"

	"encoding/json"
	"github.com/gkarlik/quark-go"
	"github.com/gkarlik/quark-go/broker"
	"github.com/gkarlik/quark-go/broker/rabbitmq"
	cb "github.com/gkarlik/quark-go/circuitbreaker"
	"github.com/stretchr/testify/assert"
	"sync"
	"time"
)

type TestService struct {
	*quark.ServiceBase
}

type TestPayload struct {
	Text string `json:"text"`
}

func TestPublishSubscribe(t *testing.T) {
	topic := "TestTopic"
	text := "This is a test message"
	key, value := "TestKey", "TestValue"

	addr, _ := quark.GetHostAddress(1234)

	brokerAddr := "amqp:///"

	ts := &TestService{
		ServiceBase: quark.NewService(
			quark.Name("TestService"),
			quark.Version("1.0"),
			quark.Address(addr),
			quark.Broker(rabbitmq.NewMessageBroker(brokerAddr)),
		),
	}
	defer ts.Dispose()

	var wg sync.WaitGroup

	wg.Add(2)
	go func() {
		messages, err := ts.Broker().Subscribe(topic)
		assert.NoError(t, err, "Subscribe returned an error")

		for msg := range messages {
			assert.Equal(t, topic, msg.Key)

			var payload TestPayload
			err := json.Unmarshal(msg.Value.([]byte), &payload)
			assert.NoError(t, err, "Unmarshal returned an error")

			assert.Equal(t, text, payload.Text)
			assert.Equal(t, value, msg.Context[key])
			wg.Done()
		}
	}()

	go func() {
		context := broker.MessageContext{}
		context[key] = value

		m := broker.Message{
			Context: context,
			Key:     topic,
			Value: &TestPayload{
				Text: text,
			},
		}

		err := ts.Broker().PublishMessage(m)
		assert.NoError(t, err, "Publish returned an error")

		wg.Done()
	}()

	wg.Wait()
}

func TestPublishSubscribeEmptyKey(t *testing.T) {
	addr, _ := quark.GetHostAddress(1234)

	brokerAddr := "amqp:///"

	ts := &TestService{
		ServiceBase: quark.NewService(
			quark.Name("TestService"),
			quark.Version("1.0"),
			quark.Address(addr),
			quark.Broker(rabbitmq.NewMessageBroker(brokerAddr)),
		),
	}
	defer ts.Dispose()

	m := broker.Message{
		Value: "TestValue",
	}

	err := ts.Broker().PublishMessage(m)
	assert.Error(t, err, "Publish should return an error")

	_, err = ts.Broker().Subscribe("")
	assert.Error(t, err, "Subscribe should return an error")
}

func TestBrokenConnection(t *testing.T) {
	addr, _ := quark.GetHostAddress(1234)

	brokerAddr := "amqp:///"

	ts := &TestService{
		ServiceBase: quark.NewService(
			quark.Name("TestService"),
			quark.Version("1.0"),
			quark.Address(addr),
			quark.Broker(rabbitmq.NewMessageBroker(brokerAddr)),
		),
	}
	defer ts.Dispose()

	// simulate broken connection
	b := ts.Broker().(*rabbitmq.MessageBroker)
	b.Connection = nil

	m := broker.Message{
		Value: "TestValue",
	}

	err := ts.Broker().PublishMessage(m)
	assert.Error(t, err, "Publish should return an error")

	_, err = ts.Broker().Subscribe("")
	assert.Error(t, err, "Subscribe should return an error")
}

func TestBrokenNetworkConnection(t *testing.T) {
	addr, _ := quark.GetHostAddress(1234)
	brokerAddr := "wrong address"

	assert.Panics(t, func() {
		ts := &TestService{
			ServiceBase: quark.NewService(
				quark.Name("TestService"),
				quark.Version("1.0"),
				quark.Address(addr),
				quark.Broker(rabbitmq.NewMessageBroker(brokerAddr, cb.Retry(1), cb.Timeout(200*time.Microsecond))),
			),
		}
		defer ts.Dispose()
	})
}
