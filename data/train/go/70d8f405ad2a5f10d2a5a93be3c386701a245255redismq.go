package redismq

import (
	"gopkg.in/redis.v5"
)

type RedisMQ struct {
	config *Config
	redis  *redis.Client
	broker IBroker
}

func New(config *Config) *RedisMQ {
	return &RedisMQ{config: config}
}

func (r *RedisMQ) Connect() error {

	r.redis = redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	r.broker = r.createBroker()

	_, err := r.redis.Ping().Result()

	return err
}

func (r *RedisMQ) Publish(queueName string, body []byte) {
	err := r.broker.Push(queueName, body)

	if err != nil {
		panic(err)
	}
}

func (r *RedisMQ) Consume(queueName string, fn callbackFunction) {
	broker := r.createBroker()
	c := newConsumer(broker, queueName)
	c.Listen(fn)
}

func (r *RedisMQ) createBroker() IBroker {
	return &BrokerRedis{client: r.redis}
}
