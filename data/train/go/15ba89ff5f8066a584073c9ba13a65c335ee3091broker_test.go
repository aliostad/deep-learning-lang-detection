package texto

import (
	"context"
	"encoding/json"
	"sync"
	"testing"

	"github.com/garyburd/redigo/redis"
	"github.com/rafaeljusto/redigomock"
	"github.com/satori/go.uuid"
	"github.com/stretchr/testify/assert"
)

func mapLen(map_ *sync.Map) int {
	length := 0
	map_.Range(func(key, value interface{}) bool {
		length++
		return true
	})
	return length
}

type DummyBroker struct {}

func newDummyBroker() *DummyBroker {
	return new(DummyBroker)
}

func (b *DummyBroker) Register(client *Client) error {
	return nil
}

func (b *DummyBroker) Unregister(client *Client) error {
	return nil
}

func (b *DummyBroker) Send(receiverID uuid.UUID, message *BrokerMessage) error {
	return nil
}

func (b *DummyBroker) Poll(ctx context.Context) error {
	return nil
}

func TestRedisBroker_Register(t *testing.T) {
	log := newLogger()
	broker := RedisBroker{
		Log: log,
		conn: redigomock.NewConn(),
		pubSubConn: redis.PubSubConn{Conn: redigomock.NewConn()},
	}
	assert.Equal(t, 0, mapLen(&broker.clients))
	firstClient := NewClient(log, nil, &broker)
	broker.Register(firstClient)
	assert.Equal(t, 1, mapLen(&broker.clients))
	broker.Register(NewClient(log, nil, &broker))
	assert.Equal(t, 2, mapLen(&broker.clients))
	broker.Register(firstClient)
	assert.Equal(t, 2, mapLen(&broker.clients))
}

func TestRedisBroker_Unregister(t *testing.T) {
	log := newLogger()
	broker := RedisBroker{
		Log: log,
		conn: redigomock.NewConn(),
		pubSubConn: redis.PubSubConn{Conn: redigomock.NewConn()},
	}
	firstClient := NewClient(log, nil, &broker)
	broker.clients.Store(firstClient.ID.String(), firstClient)
	secondClient := NewClient(log, nil, &broker)
	broker.clients.Store(secondClient.ID.String(), secondClient)
	thirdClient := NewClient(log, nil, &broker)
	broker.clients.Store(thirdClient.ID.String(), thirdClient)
	assert.Equal(t, 3, mapLen(&broker.clients))
	broker.Unregister(thirdClient)
	assert.Equal(t, 2, mapLen(&broker.clients))
	broker.Unregister(secondClient)
	assert.Equal(t, 1, mapLen(&broker.clients))
	broker.Unregister(firstClient)
	assert.Equal(t, 0, mapLen(&broker.clients))
}

func TestRedisBroker_Send(t *testing.T) {
	message := new(BrokerMessage)
	message.SenderID = uuid.NewV4()
	message.RecipientID = uuid.NewV4()
	message.Text = "Lotem ipsum dolor sit amet..."
	log := newLogger()
	mockConn := redigomock.NewConn()
	broker := RedisBroker{
		Log: log,
		conn: mockConn,
		pubSubConn: redis.PubSubConn{Conn: redigomock.NewConn()},
	}
	err := broker.Send(message.RecipientID, message)
	assert.Error(t, err)
	marshaled, _ := json.Marshal(message)
	mockConn.Command("PUBLISH", "texto:" + message.RecipientID.String(), marshaled).Expect("ok")
	err = broker.Send(message.RecipientID, message)
	assert.Nil(t, err)
}
