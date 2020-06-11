// Package broker is used to distribute tasks
package broker

import (
	"encoding/json"

	"github.com/go-redis/redis"
	"github.com/xuqingfeng/pagestat/vars"
)

type Broker struct {
	Client *redis.Client
}

func New(c Config) *Broker {

	client := redis.NewClient(&redis.Options{
		Addr:     c.RedisUrl,
		Password: c.RedisPassword,
	})

	return &Broker{client}
}

func (b *Broker) Publish(task vars.Task) error {

	taskInBytes, err := json.Marshal(task)
	if err != nil {
		return err
	}
	_, err = b.Client.Publish(vars.Channel, string(taskInBytes)).Result()
	return err
}

func (b *Broker) Stop() {

	b.Client.Close()
}
