package main

import (
	"fmt"
	"time"

	"github.com/micro/federation-srv/federation"
	"github.com/micro/go-os/config"
	"github.com/micro/go-os/config/source/file"

	"github.com/micro/go-micro/broker"
	"github.com/micro/go-micro/broker/http"
	"github.com/micro/go-plugins/broker/kafka"
	"github.com/micro/go-plugins/broker/nats"
	"github.com/micro/go-plugins/broker/nsq"
	"github.com/micro/go-plugins/broker/rabbitmq"
)

var (
	plugins = map[string]func(...broker.Option) broker.Broker{
		"http":     http.NewBroker,
		"kafka":    kafka.NewBroker,
		"nats":     nats.NewBroker,
		"nsq":      nsq.NewBroker,
		"rabbitmq": rabbitmq.NewBroker,
	}
)

// subscribe to publishers
func subscribe(topic string, config federation.Topic, brokers map[string]federation.Broker) {
	for _, r := range config.Publish {
		for name, b := range brokers[r] {
			fn, ok := plugins[name]
			if !ok {
				continue
			}

			br := fn(broker.Addrs(b.Hosts...))
			br.Init()
			br.Connect()
			fmt.Println("Subscribing to", topic, name, b.Hosts)
			br.Subscribe(topic+".federated", func(p broker.Publication) error {
				fmt.Printf("[region %s][topic %s][plugin %s] Received message %+v\n", r, p.Topic(), br.String(), string(p.Message().Body))
				return nil
			})
		}
	}
}

// publish to subscribers
func publish(topic string, config federation.Topic, brokers map[string]federation.Broker) {
	for _, r := range config.Subscribe {
		for name, b := range brokers[r] {
			fn, ok := plugins[name]
			if !ok {
				continue
			}

			t := time.NewTicker(time.Millisecond * 500)
			br := fn(broker.Addrs(b.Hosts...))
			br.Init()
			br.Connect()

			go func() {
				msg := fmt.Sprintf("This is a message to topic %s from plugin %s", topic, br.String())

				for _ = range t.C {
					fmt.Printf("[region %s][topic %s][plugin %s] published msg\n", r, topic, br.String())
					br.Publish(topic, &broker.Message{Body: []byte(msg)})
				}
			}()
		}
	}
}

func main() {
	source := file.NewSource(config.SourceName("test.json"))
	c := config.NewConfig(config.WithSource(source))

	var topics map[string]federation.Topic
	if err := c.Get("federation", "topics").Scan(&topics); err != nil {
		fmt.Println(err)
		return
	}

	var brokers map[string]federation.Broker
	if err := c.Get("federation", "brokers").Scan(&brokers); err != nil {
		fmt.Println(err)
		return
	}

	for name, topic := range topics {
		go subscribe(name, topic, brokers)
		go publish(name, topic, brokers)
	}

	<-time.After(time.Second * 10)
}
