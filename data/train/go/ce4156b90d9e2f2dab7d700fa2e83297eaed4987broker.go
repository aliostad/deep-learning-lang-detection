package main

import (
	"encoding/json"

	redis "gopkg.in/redis.v5"
)

// A Broker represents a connection to a message broker
type Broker struct {
	client *redis.Client
	topic  string
}

// NewBroker creates and return a new broker
func NewBroker(config *tomlConfig) Broker {
	client := redis.NewClient(&redis.Options{
		Addr: config.Redis.Host,
	})
	return Broker{client, config.Redis.Topic}
}

// Send publishes a Message to the message broker
func (b Broker) Send(message Message) error {
	msgJSON, err := json.Marshal(message)
	if err != nil {
		return err
	}
	return b.client.Publish(b.topic, string(msgJSON)).Err()
}
